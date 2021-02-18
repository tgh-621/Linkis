import sys, getopt, traceback, json, re
import os
os.environ['PYSPARK_ALLOW_INSECURE_GATEWAY']='1'
zipPaths = sys.argv[4]
paths = zipPaths.split(':')
for i in range(len(paths)):
    sys.path.insert(0, paths[i])

from py4j.java_gateway import java_import, JavaGateway, GatewayClient, GatewayParameters
from py4j.protocol import Py4JJavaError
from pyspark.conf import SparkConf
from pyspark.context import SparkContext
from pyspark.sql.session import SparkSession
from pyspark.rdd import RDD
from pyspark.files import SparkFiles
from pyspark.storagelevel import StorageLevel
from pyspark.accumulators import Accumulator, AccumulatorParam
from pyspark.broadcast import Broadcast
from pyspark.serializers import MarshalSerializer, PickleSerializer
import base64
from io import BytesIO
try:
  from StringIO import StringIO
except ImportError:
  from io import StringIO

# for back compatibility
from pyspark.sql import SQLContext, HiveContext, Row

def setup_matplotlib():
    # If we don't have matplotlib installed don't bother continuing
    try:
        import matplotlib
    except ImportError:
        return
    try:
        matplotlib.use('module://backend_zinline')
        import backend_zinline

        # Everything looks good so make config assuming that we are using
        # an inline backend
        self.configure_mpl(width=600, height=400, dpi=72,
                           fontsize=10, interactive=True, format='png')
    except ImportError:
        # Fall back to Agg if no custom backend installed
        matplotlib.use('Agg')
        print("Unable to load inline matplotlib backend, "
              "falling back to Agg")
setup_matplotlib()

class Logger(object):
    def __init__(self):
        self.out = ""

    def write(self, message):
        intp.appendOutput(message)

    def reset(self):
        self.out = ""

    def flush(self):
        pass

class ErrorLogger(object):
    def __init__(self):
        self.out = ""

    def write(self, message):
        intp.appendErrorOutput(message)

    def reset(self):
        self.out = ""

    def flush(self):
        pass


class SparkVersion(object):
    SPARK_1_4_0 = 140
    SPARK_1_3_0 = 130

    def __init__(self, versionNumber):
        self.version = versionNumber

    def isAutoConvertEnabled(self):
        return self.version >= self.SPARK_1_4_0

    def isImportAllPackageUnderSparkSql(self):
        return self.version >= self.SPARK_1_3_0

try:
    client = GatewayClient(port=int(sys.argv[1]),
                           gateway_parameters=GatewayParameters(port = int(sys.argv[1]), auto_convert = True, auth_token = sys.argv[3]))
except:
    client = GatewayClient(port=int(sys.argv[1]))

sparkVersion = SparkVersion(int(sys.argv[2]))

if sparkVersion.isAutoConvertEnabled():
    try:
        gateway = JavaGateway(client, auto_field = True, auto_convert = True,
                              gateway_parameters=GatewayParameters(port = int(sys.argv[1]), auto_convert = True, auth_token = sys.argv[3]))
    except:
        gateway = JavaGateway(client, auto_convert = True)
else:
    gateway = JavaGateway(client)

java_import(gateway.jvm, "org.apache.spark.SparkEnv")
java_import(gateway.jvm, "org.apache.spark.SparkConf")
java_import(gateway.jvm, "org.apache.spark.api.java.*")
java_import(gateway.jvm, "org.apache.spark.api.python.*")
java_import(gateway.jvm, "org.apache.spark.mllib.api.python.*")

intp = gateway.entry_point

if sparkVersion.isImportAllPackageUnderSparkSql():
    java_import(gateway.jvm, "org.apache.spark.sql.*")
    java_import(gateway.jvm, "org.apache.spark.sql.hive.*")
else:
    java_import(gateway.jvm, "org.apache.spark.sql.SQLContext")
    java_import(gateway.jvm, "org.apache.spark.sql.hive.HiveContext")
    java_import(gateway.jvm, "org.apache.spark.sql.hive.LocalHiveContext")
    java_import(gateway.jvm, "org.apache.spark.sql.hive.TestHiveContext")

jobGroup = ""

output = Logger()
errorOutput = ErrorLogger()
sys.stdout = output
sys.stderr = errorOutput

def show(obj):
    from pyspark.sql import DataFrame
    if isinstance(obj, DataFrame):
        # print(intp.showDF(jobGroup, obj._jdf))
        intp.showDF(jobGroup, obj._jdf)
    else:
        print((str(obj)))

def showAlias(obj,alias):
    from pyspark.sql import DataFrame
    if isinstance(obj, DataFrame):
        # print(intp.showDF(jobGroup, obj._jdf))
        intp.showAliasDF(jobGroup, obj._jdf,alias)
    else:
        print((str(obj)))

def show_matplotlib(p, fmt="png", width="auto", height="auto", **kwargs):
    """Matplotlib show function
    """
    if fmt == "png":
        img = BytesIO()
        p.savefig(img, format=fmt)
        img_str = b"data:image/png;base64,"
        img_str += base64.b64encode(img.getvalue().strip())
        img_tag = "<img src={img} style='width={width};height:{height}'>"
        # Decoding is necessary for Python 3 compability
        img_str = img_str.decode("utf-8")
        img_str = img_tag.format(img=img_str, width=width, height=height)
    elif fmt == "svg":
        img = StringIO()
        p.savefig(img, format=fmt)
        img_str = img.getvalue()
    else:
        raise ValueError("fmt must be 'png' or 'svg'")

    html = "<div style='width:{width};height:{height}'>{img}<div>"
    intp.showHTML(jobGroup,html.format(width=width, height=height, img=img_str))
    img.close()


def saveDFToCsv(df, path, hasheader=True,isOverwrite=False,option={}):
    from pyspark.sql import DataFrame
    from py4j.java_collections import MapConverter
    if isinstance(df, DataFrame):
        intp.saveDFToCsv(df._jdf, path, hasheader, isOverwrite, MapConverter().convert(option,gateway._gateway_client))
    else:
        print(str(df))

java_import(gateway.jvm, "scala.Tuple2")

jsc = intp.getJavaSparkContext()
jconf = intp.getSparkConf()
conf = SparkConf(_jvm = gateway.jvm, _jconf = jconf)
sc = SparkContext(jsc=jsc, gateway=gateway, conf=conf)
sqlc = HiveContext(sc, intp.sqlContext())
sqlContext = sqlc
spark = SparkSession(sc, intp.getSparkSession())

##add pyfiles
try:
    pyfile = sys.argv[5]
    pyfiles = pyfile.split(',')
    for i in range(len(pyfiles)):
        if ""!=pyfiles[i]:
            sc.addPyFile(pyfiles[i])
except Exception as e:
    print("add pyfile error: " + pyfile)

class UDF(object):
    def __init__(self, intp, sqlc):
        self.intp = intp
        self.sqlc = sqlc
    def register(self, udfName, udf):
        self.sqlc.registerFunction(udfName, udf)

udf = UDF(intp, sqlc)
intp.onPythonScriptInitialized()

while True :
    req = intp.getStatements()
    try:
        stmts = req.statements().split("\n")
        jobGroup = req.jobGroup()
        final_code = None

        for bdp_dwc_s in stmts:
            if bdp_dwc_s == None:
                continue

            # skip comment
            s_stripped = bdp_dwc_s.strip()
            if len(s_stripped) == 0 or s_stripped.startswith("#"):
                continue

            if final_code:
                final_code += "\n" + bdp_dwc_s
            else:
                final_code = bdp_dwc_s

        if final_code:
            compiledCode = compile(final_code, "<string>", "exec")
            sc.setJobGroup(jobGroup, final_code)
            eval(compiledCode)

        intp.setStatementsFinished("", False)
    except Py4JJavaError:
        excInnerError = traceback.format_exc() # format_tb() does not return the inner exception
        innerErrorStart = excInnerError.find("Py4JJavaError:")
        if innerErrorStart > -1:
            excInnerError = excInnerError[innerErrorStart:]
        intp.setStatementsFinished(excInnerError + str(sys.exc_info()), True)
    except:
        msg = traceback.format_exc()
        intp.setStatementsFinished(msg, True)

    output.reset()