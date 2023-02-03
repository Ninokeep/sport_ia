from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from os import path
from sqlalchemy import create_engine
from flask_login import LoginManager

db = SQLAlchemy()
DB_NAME="ia_sport"
DB_USER = "root"
DB_PASSWORD= "password"
DB_PORT="3306"
DB_HOST="localhost"
def create_app():
    app = Flask(__name__)
    
    
    app.config['SECRET_KEY'] = 'fabrizio'
    app.config['SQLALCHEMY_DATABASE_URI'] = f'mysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}'
    #engine =  create_engine(f'mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}')
    
    
    db.init_app(app)
    

    
    
    
    from .views import views
    from .auth import auth
    from .classes.squat import Squat
    from .classes.pushup import Pushup
    from .classes.poseDetector.PoseDetector import PoidsDuBras
    
    app.register_blueprint(views,url_prefix="/")
    app.register_blueprint(auth, url_prefix="/")
    
    from .models import User, Session, SessionMeta, Entrainement
   
    login_manager = LoginManager()
    login_manager.login_view = 'auth.login'
    login_manager.login_message = u"Veuillez vous connecter"
    login_manager.login_message_category = "error"

    login_manager.init_app(app)
    
    @login_manager.user_loader
    def load_user(id):
        return User.query.get(int(id))
    
    return app


