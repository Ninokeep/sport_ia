from flask import Blueprint,render_template, request, flash, redirect
from flask.helpers import url_for
from .models import User,Session
from werkzeug.security import generate_password_hash, check_password_hash
from . import db
from flask_login import login_user, login_required, logout_user, current_user
from flask_bcrypt import Bcrypt
auth = Blueprint('auth', __name__)


@auth.route('/login' ,methods=['GET','POST'] )
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        user = User.query.filter_by(email=email).first()
        deux = "fabrizio"
        bcrypt = Bcrypt()

        if user:
            if bcrypt.check_password_hash(user.password, password):
            # if check_password_hash(user.password, password):
                flash('Connexion réussie !', category="success")
                login_user((user), remember=True)
                
                return redirect(url_for('views.home'))
            else:
                flash('Mauvais mot de passe, essaie de nouveau.', category="error")
        else:
            flash("L'émail n'existe pas", category="error")
    return render_template("login.html", user= current_user)


@auth.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('auth.login'))


@auth.route('/sign-up', methods=["GET", "POST"])

def signup():
    if request.method == 'POST':
        nom = request.form.get('nom')
        prenom = request.form.get('prenom')
        email = request.form.get('email')
        password = request.form.get('password')
        password2= request.form.get('password2')
        sexe = request.form.get('sexe')
        user = User.query.filter_by(email=email).first()
        print(request.form)
        if user:
            flash("L'émail existe déjà ! ", category="error")
        elif len(email) < 4:
            flash("L'émail doit être plus grand que 4 caractéres.", category="error")
        elif len(nom) < 2:
            flash("Le nom doit être plus grand que 2 caractéres.", category="error") 
        elif len(prenom) < 2:
            flash("Le prenom doit être plus grand que 2 caractéres.", category="error")
        # elif sexe == "Homme" or sexe == "Femme":
        #     flash("Le sexe doit être un homme ou une femme", category="error") 
        elif password != password2:
            flash("Le mot de passe ne correspond pas .", category="error") 
        elif len(password) < 7:
            flash("Le mot de passe doit être plus grand que 7 caractéres.", category="error")
        else:
            if sexe == "Homme":
                sexe_bool = False
            elif sexe == "Femme":
                sexe_bool = True
            new_user = User( nom=nom , prenom=prenom , email=email , sexe=sexe_bool, password=generate_password_hash(password,method='sha256')  )
            db.session.add(new_user)
            db.session.commit()
            login_user(new_user, remember=True)
            flash('compte créé', category="success")
            return redirect(url_for('views.home'))
    return render_template("sign_up.html", user=current_user)