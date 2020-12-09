/*
 * Copyright 2019 WeBank
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.webank.wedatasphere.linkis.entrance.executer

import java.util

import com.webank.wedatasphere.linkis.common.exception.WarnException
import com.webank.wedatasphere.linkis.common.utils.Logging
import com.webank.wedatasphere.linkis.datasourcemanager.common.protocol.{DsInfoQueryRequest, DsInfoResponse}
import com.webank.wedatasphere.linkis.entrance.cache.UserConfiguration
import com.webank.wedatasphere.linkis.entrance.exception.JDBCParamsIllegalException
import com.webank.wedatasphere.linkis.entrance.execute._
import com.webank.wedatasphere.linkis.entrance.execute.impl.EntranceExecutorManagerImpl
import com.webank.wedatasphere.linkis.protocol.config.RequestQueryAppConfigWithGlobal
import com.webank.wedatasphere.linkis.protocol.constants.TaskConstant
import com.webank.wedatasphere.linkis.rpc.Sender
import com.webank.wedatasphere.linkis.scheduler.executer.Executor
import com.webank.wedatasphere.linkis.scheduler.listener.ExecutorListener
import com.webank.wedatasphere.linkis.scheduler.queue.{GroupFactory, Job, SchedulerEvent}
import org.apache.commons.lang.StringUtils

import scala.concurrent.duration.Duration

class JDBCEngineExecutorManagerImpl(groupFactory: GroupFactory,
                                    engineBuilder: EngineBuilder,
                                    engineRequester: EngineRequester,
                                    engineSelector: EngineSelector,
                                    engineManager: EngineManager,
                                    entranceExecutorRulers: Array[EntranceExecutorRuler])
  extends EntranceExecutorManagerImpl(groupFactory,engineBuilder, engineRequester,
    engineSelector, engineManager, entranceExecutorRulers) with Logging{
  private val JDBCEngineExecutor = new util.HashMap[String, JDBCEngineExecutor]()
  logger.info("JDBC EngineManager Registered")
  override protected def createExecutor(event: SchedulerEvent): EntranceEngine = event match {
    case job: JDBCEntranceJob =>
      val JDBCParams = new util.HashMap[String, String]()
      val params = job.getParams
      var (url, userName, password) = getDatasourceInfo(params)
      //如果jobparams中没有jdbc连接,从configuration中获取
      if(StringUtils.isEmpty(url)||StringUtils.isEmpty(userName)||StringUtils.isEmpty(password)){
        val jdbcConfiguration = UserConfiguration.getCacheMap(RequestQueryAppConfigWithGlobal(job.getUser,job.getCreator,"jdbc",true))
        url = jdbcConfiguration.get("jdbc.url")
        userName = jdbcConfiguration.get("jdbc.username")
        password = jdbcConfiguration.get("jdbc.password")
      }
      JDBCParams.put("jdbc.url",url)
      JDBCParams.put("jdbc.username",userName)
      JDBCParams.put("jdbc.password",password)
      if (!StringUtils.isEmpty(url) && !StringUtils.isEmpty(userName) && !StringUtils.isEmpty(password)) {
        JDBCEngineExecutor.put(url + ":" + userName + ":" + password, new JDBCEngineExecutor(5000, JDBCParams))
        new JDBCEngineExecutor(5000, JDBCParams)
      }else {
        logger.error(s"jdbc url is $url, jdbc username is $userName")
        throw JDBCParamsIllegalException("jdbc url or username or password may be null at least")
      }
  }

  override def setExecutorListener(executorListener: ExecutorListener): Unit = ???

  override def askExecutor(event: SchedulerEvent): Option[Executor] = event match{
    case job:JDBCEntranceJob =>
      findUsefulExecutor(job).orElse(Some(createExecutor(event)))
    case _ => None
  }


  override def askExecutor(event: SchedulerEvent, wait: Duration): Option[Executor] = event match {
    case job:JDBCEntranceJob =>
      findUsefulExecutor(job).orElse(Some(createExecutor(event)))
    case _ => None
  }


  private def findUsefulExecutor(job: Job): Option[Executor] = job match{
    case job:JDBCEntranceJob =>
      val params: util.Map[String, Any] = job.getParams
      logger.info("BEGAIN TO GET configuration：" +params.get("configuration"))
      var (url, userName, password) = getDatasourceInfo(params)
      //如果jobparams中没有jdbc连接,从configuration中获取
      if(StringUtils.isEmpty(url)||StringUtils.isEmpty(userName)||StringUtils.isEmpty(password)){
        val jdbcConfiguration = UserConfiguration.getCacheMap(RequestQueryAppConfigWithGlobal(job.getUser,job.getCreator,"jdbc",true))
        url = jdbcConfiguration.get("jdbc.url")
        userName = jdbcConfiguration.get("jdbc.username")
        password = jdbcConfiguration.get("jdbc.password")
      }
      val key = url + ":" + userName + ":" + password
      logger.info("findUsefulExecutor - datasource key: " + key + ", cachedKey: " + JDBCEngineExecutor.keySet())
      if (JDBCEngineExecutor.containsKey(key)){
        Some(JDBCEngineExecutor.get(key))
      }else{
        None
      }
  }

  val sender : Sender = Sender.getSender("dsm-server")
  def getDatasourceInfo(params : util.Map[String, Any]) : (String, String, String) = {
    val datasourceId = params.get("configuration").asInstanceOf[util.Map[String, Any]]
      .getOrDefault(TaskConstant.PARAMS_CONFIGURATION_RUNTIME, new util.HashMap[String, Any]())
      .asInstanceOf[util.Map[String, Any]]
      .getOrDefault(TaskConstant.PARAMS_CONFIGURATION_DATASOURCE, new util.HashMap[String, Any]())
      .asInstanceOf[util.Map[String, Any]].get("datasourceId")
    logger.info(s"begin to get datasource info from dsm, datasourceId: ${datasourceId}")
    if (datasourceId != null) {
      val ds = sender.ask(DsInfoQueryRequest(String.valueOf(datasourceId), "BDP")) match {
        case r: DsInfoResponse => r
        case warn: WarnException => throw warn
      }
      logger.info(s"get datasource info result: ${ds}")
      if (ds.status) {
        val url = ds.params.get("jdbc.url").asInstanceOf[String]
        val userName = ds.params.get("jdbc.username").asInstanceOf[String]
        val password = ds.params.get("jdbc.password").asInstanceOf[String]
        logger.info(s"get from dsm: url: ${url}, username: ${userName}, password: ${password}")
        return (url, userName, password)
      }
    }

    ("", "", "")
  }

  override def getById(id: Long): Option[Executor] = ???

  override def getByGroup(groupName: String): Array[Executor] = ???

  override protected def delete(executor: Executor): Unit = ???

  override def shutdown(): Unit = ???

}
