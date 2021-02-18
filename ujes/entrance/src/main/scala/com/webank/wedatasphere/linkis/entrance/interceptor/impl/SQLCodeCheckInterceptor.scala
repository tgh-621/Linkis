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

package com.webank.wedatasphere.linkis.entrance.interceptor.impl

import com.webank.wedatasphere.linkis.entrance.interceptor.EntranceInterceptor
import com.webank.wedatasphere.linkis.entrance.interceptor.exception.CodeCheckException
import com.webank.wedatasphere.linkis.protocol.query.RequestPersistTask
import com.webank.wedatasphere.linkis.protocol.task.Task

/**
  * created by enjoyyin on 2018/10/22
  * Description:
  */
class SQLCodeCheckInterceptor extends EntranceInterceptor{

  override def apply(task: Task, logAppender: java.lang.StringBuilder): Task = task match {
    case requestPersistTask:RequestPersistTask =>
      requestPersistTask.getEngineType.toLowerCase() match {
        case "hql" | "sql" | "jdbc"|"hive" | "psql" | "essql" =>
          val sb:StringBuilder = new StringBuilder
          val isAuth:Boolean = SQLExplain.authPass(requestPersistTask.getExecutionCode, sb)
          if (!isAuth) {
            throw CodeCheckException(20051, "sql code check failed, reason is " + sb.toString())
          }
        case _ =>
        }
      requestPersistTask
  }
}
