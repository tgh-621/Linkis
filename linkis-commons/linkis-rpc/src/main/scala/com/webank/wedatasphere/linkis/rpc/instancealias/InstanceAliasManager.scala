package com.webank.wedatasphere.linkis.rpc.instancealias

import com.webank.wedatasphere.linkis.common.ServiceInstance
import javax.annotation.Nullable

trait InstanceAliasManager {

  def getAliasByServiceInstance(instance: ServiceInstance): String

  def getAliasByInstance(instance: String): String

  @Nullable
  def getInstanceByAlias(alias: String): ServiceInstance

  def refresh(): Unit

  def getAllInstanceList(): java.util.List[ServiceInstance]

  def isInstanceAliasValid(alias: String): Boolean
}
