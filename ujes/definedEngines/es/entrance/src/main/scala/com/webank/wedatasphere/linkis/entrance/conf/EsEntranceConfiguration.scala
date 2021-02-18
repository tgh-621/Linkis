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
package com.webank.wedatasphere.linkis.entrance.conf

import com.webank.wedatasphere.linkis.common.conf.{ByteType, CommonVars}

/**
 *
 * @author wang_zh
 * @date 2020/5/6
 */
object EsEntranceConfiguration {

  // es client
  val ES_CLUSTER = CommonVars("wds.linkis.es.cluster", "")
  val ES_DATASOURCE_NAME = CommonVars("wds.linkis.datasource", "default_datasource")
  val ES_AUTH_CACHE = CommonVars("wds.linkis.es.auth.cache", false)
  val ES_USERNAME = CommonVars("wds.linkis.es.username", "")
  val ES_PASSWORD = CommonVars("wds.linkis.es.password", "")
  val ES_SNIFFER_ENABLE = CommonVars("wds.linkis.es.sniffer.enable", false)
  val ES_HTTP_METHOD = CommonVars("wds.linkis.es.http.method", "GET")
  val ES_HTTP_ENDPOINT = CommonVars("wds.linkis.es.http.endpoint", "/_search")
  val ES_HTTP_SQL_ENDPOINT = CommonVars("wds.linkis.es.sql.endpoint", "/_sql")
  val ES_SQL_FORMAT = CommonVars("wds.linkis.es.sql.format", "{\"query\": \"%s\"}")
  val ES_HTTP_HEADER_PREFIX = "wds.linkis.es.headers."

  // entrance resource
  val ENTRANCE_MAX_JOB_INSTANCE = CommonVars("wds.linkis.entrance.max.job.instance", 100)
  val ENTRANCE_PROTECTED_JOB_INSTANCE = CommonVars("wds.linkis.entrance.protected.job.instance", 20)
  val ENGINE_DEFAULT_LIMIT = CommonVars("wds.linkis.engine.default.limit", 5000)

  // resultSet
  val ENGINE_RESULT_SET_MAX_CACHE = CommonVars("wds.linkis.resultSet.cache.max", new ByteType("512k"))
}
