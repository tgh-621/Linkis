/**
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
package com.webank.wedatasphere.linkis.entrance.execute

import java.util

import com.webank.wedatasphere.linkis.common.utils.Logging
import com.webank.wedatasphere.linkis.entrance.event.EntranceEvent
import com.webank.wedatasphere.linkis.resourcemanager.domain.ModuleInfo
import com.webank.wedatasphere.linkis.resourcemanager.service.annotation.{EnableResourceManager, RegisterResource}
import com.webank.wedatasphere.linkis.scheduler.executer.{Executor, ExecutorState}
import com.webank.wedatasphere.linkis.scheduler.executer.ExecutorState.{Busy, ExecutorState, Idle}
import org.apache.commons.io.IOUtils

import scala.collection.JavaConversions._

/**
 *
 * @author wang_zh
 * @date 2020/5/11
 */
@EnableResourceManager
class EsEngineManager(resources: ModuleInfo) extends EngineManager with Logging {

  private val idToEngines = new util.HashMap[Long, EntranceEngine]

  /**
   * The user initializes the operation. When the entance is started for the first time, all the engines are obtained through this method, and the initialization operation is completed.
   * 用户初始化操作，第一次启动entrance时，将通过该方法，拿到所有的engine，完成初始化操作
   */
  override def readAliveEngines(): Unit = { }

  override def get(id: Long): EntranceEngine = idToEngines.get(id)

  override def get(instance: String): Option[EntranceEngine] = ???

  override def listEngines(op: EntranceEngine => Boolean): Array[EntranceEngine] = idToEngines.values().filter(e => op(e)).toArray

  override def addNotExistsEngines(engine: EntranceEngine*): Unit =
    engine.foreach{e =>
      if(!idToEngines.containsKey(e.getId)) idToEngines synchronized {
        if(!idToEngines.containsKey(e.getId)) {
          idToEngines.put(e.getId, e)
          info(toString + "：add a new engine => " + e)
        }
      }
    }

  override def delete(id: Long): Unit = if(idToEngines.containsKey(id)) idToEngines synchronized {
    if(idToEngines.containsKey(id)) {
      val engine = idToEngines.remove(id)
      IOUtils.closeQuietly(engine)
      info(s"deleted engine $engine.")
    }
  }

  override def onEvent(event: EntranceEvent): Unit = { }

  override def onEventError(event: EntranceEvent, t: Throwable): Unit = {
    error(s"deal event $event failed!", t)
  }

  override def onExecutorCreated(executor: Executor): Unit = executor match {
    case engine: EntranceEngine => addNotExistsEngines(engine)
  }

  override def onExecutorCompleted(executor: Executor, message: String): Unit = executor match {
    case engine: EntranceEngine => delete(engine.getId)
  }

  override def onExecutorStateChanged(executor: Executor, fromState: ExecutorState, toState: ExecutorState): Unit = executor match {
    case engine: EntranceEngine =>
      toState match {
//        case Idle =>
//        case Busy =>
        case state if ExecutorState.isCompleted(state) =>
          delete(executor.getId)
        case _ =>
      }
  }

  /**
   * Registered resources(注册资源)
   */
  @RegisterResource
  def registerResources(): ModuleInfo = resources

}
