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

package com.webank.wedatasphere.linkis.storage.script.compaction


class ShellScriptCompaction private extends CommonScriptCompaction{
  override def prefixConf: String = "#conf@set"

  override def prefix: String = "#@set"

  override def belongTo(suffix: String): Boolean ={
    suffix match {
      case "sh"=>true
      case _=>false
    }
  }
}
object ShellScriptCompaction{
  val shellScriptCompaction:ShellScriptCompaction=new ShellScriptCompaction

  def apply(): CommonScriptCompaction = shellScriptCompaction
}
