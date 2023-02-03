from . import db
from flask_login import UserMixin


class User(db.Model, UserMixin):
    id = db.Column(db.Integer,primary_key=True)
    email = db.Column(db.String(150),unique = True)
    nom = db.Column(db.String(150))
    prenom = db.Column(db.String(150))
    password = db.Column(db.String(150))
    sexe = db.Column(db.Boolean)
    age = db.Column(db.Integer)
    pathologie = db.Column(db.String(150),nullable= True)
    seance_restante = db.Column(db.Integer)
    
class Session(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    id_user = db.Column(db.Integer, db.ForeignKey('user.id'))
    id_entrainement = db.Column(db.Integer, db.ForeignKey('entrainement.id'))
    fini = db.Column(db.Boolean, default=0)
    message_user  = db.Column(db.String(150), nullable=True)
    repetition_fait = db.Column(db.Integer, default=0)
    commentaire_kine = db.Column(db.String(255))
    
class SessionMeta(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    meta_name =  db.Column(db.String(150))
    meta_value = db.Column(db.Integer) 
    id_session = db.Column(db.Integer, db.ForeignKey('session.id'))   
 
class Entrainement(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nom = db.Column(db.String(150))
    niveau = db.Column(db.Integer)
    gif = db.Column(db.LargeBinary,nullable= True)
    