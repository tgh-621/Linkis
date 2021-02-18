package com.webank.wedatasphere.linkis.bml.hook

import java.io.File
import java.util

import com.webank.wedatasphere.linkis.bml.client.{BmlClient, BmlClientFactory}
import com.webank.wedatasphere.linkis.bml.conf.BmlHookConf
import com.webank.wedatasphere.linkis.bml.exception.BmlHookDownloadException
import com.webank.wedatasphere.linkis.bml.utils.BmlHookUtils
import com.webank.wedatasphere.linkis.common.exception.ErrorException
import com.webank.wedatasphere.linkis.common.utils.{Logging, Utils}
import com.webank.wedatasphere.linkis.engine.ResourceExecuteRequest
import com.webank.wedatasphere.linkis.engine.execute.EngineExecutorContext
import com.webank.wedatasphere.linkis.engine.extension.EnginePreExecuteHook
import com.webank.wedatasphere.linkis.scheduler.executer.ExecuteRequest
import org.apache.commons.lang.StringUtils

import scala.collection.JavaConversions._
/**
  * created by cooperyang on 2019/9/23
  * Description:
  */
class BmlEnginePreExecuteHook extends EnginePreExecuteHook with Logging{
  override val hookName: String = "BmlEnginePreExecuteHook"

  val RESOURCES_STR = "resources"

  val RESOURCE_ID_STR = "resourceId"

  val VERSION_STR = "version"

  val FILE_NAME_STR = "fileName"

  val processUser:String = System.getProperty("user.name")

  val defaultUser:String = "hadoop"

  val bmlClient:BmlClient = if (StringUtils.isNotEmpty(processUser))
    BmlClientFactory.createBmlClient(processUser) else BmlClientFactory.createBmlClient(defaultUser)

  val seperator:String = File.separator

  val pathType:String = "file://"

  override def callPreExecuteHook(engineExecutorContext: EngineExecutorContext, executeRequest: ExecuteRequest, code: String): String = {
    val workDir = BmlHookConf.WORK_DIR_STR.getValue
    val jobId = engineExecutorContext.getJobId
    var hookCode = code
    executeRequest match {
      case resourceExecuteRequest:ResourceExecuteRequest => val resources = resourceExecuteRequest.resources
        if (null == resources) return hookCode
        val resourcePaths = resources map {
          case resource:util.Map[String, Object] => val fileName = resource.get(FILE_NAME_STR).toString
            val resourceId = resource.get(RESOURCE_ID_STR).toString
            val version = resource.get(VERSION_STR).toString
            val fullPath = if (workDir.endsWith(seperator)) pathType + workDir + fileName else
              pathType + workDir + seperator + fileName
            val response = Utils.tryCatch{
              bmlClient.downloadResource(processUser, resourceId, version, fullPath, true)
            }{
              case error:ErrorException => logger.error("download resource for {} failed", error)
                throw error
              case t:Throwable => logger.error(s"download resource for $jobId failed", t)
                val e1 = BmlHookDownloadException(t.getMessage)
                e1.initCause(t)
                throw t
            }
            if (response.isSuccess){
              logger.info(s"for job $jobId resourceId $resourceId version $version download to path $fullPath ok")
              fullPath
            }else{
              logger.warn(s"for job $jobId resourceId $resourceId version $version download to path $fullPath Failed")
              null
            }
          case _ =>
            logger.warn("job resource cannot download")
            null
        }
        hookCode = if (StringUtils.isNotBlank(hookCode)) hookCode else executeRequest.code
        hookCode = callResourcesDownloadedHook(resourcePaths.toArray, engineExecutorContext, executeRequest, hookCode)
      case _ =>
    }
    if (StringUtils.isNotBlank(hookCode)) hookCode else executeRequest.code
  }

  def callResourcesDownloadedHook(resourcePaths: Array[String], engineExecutorContext: EngineExecutorContext, executeRequest: ExecuteRequest, code: String): String = {
    code
  }
}
