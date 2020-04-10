from flask import Flask
import os

app = Flask(__name__, static_url_path='',  static_folder='../dist/rdbox-gui/')

if os.environ.get('DEBUG_RDBOX_GUI', 'True').lower() in ("yes", "true", "t", "1"):
    app.config.from_object('flask_rdbox.config')
else:
    app.config.from_object('flask_rdbox.config_prod')

from flask_rdbox.views import entries # noqa: 402
from flask_rdbox.views import g_cloud_setupper # noqa: 402


@app.route('/', methods=['GET'])
def getAngular():
    return app.send_static_file('index.html')
