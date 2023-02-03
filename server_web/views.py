
from flask import Blueprint,render_template, request, flash,redirect,url_for, Response
from flask_login import  login_required,  current_user
from . import db
from .models import Session as SessionUser, User, SessionMeta, Entrainement


from .classes.poseDetector.PoseDetector import  PoseDetector 



views = Blueprint('views', __name__)


def exercice(nom,niveau):
    if nom.lower() == "jambe":
        if niveau.lower() == "debutant":
            return  PoseDetector(0,"LEFT_HIP","LEFT_KNEE","LEFT_ANKLE",160,140)  
        elif niveau.lower() == "intermediaire":
            return  PoseDetector(0,"LEFT_HIP","LEFT_KNEE","LEFT_ANKLE",170,100)  
        else:
            return  PoseDetector(0,"LEFT_HIP","LEFT_KNEE","LEFT_ANKLE",170,80)  
    elif nom.lower() == "pompe":
        if niveau.lower() == "debutant":
            return  PoseDetector(0,"LEFT_SHOULDER","LEFT_ELBOW","LEFT_WRIST",160,90)  
        elif niveau.lower() == "intermediaire":
            return  PoseDetector(0,"LEFT_SHOULDER","LEFT_ELBOW","LEFT_WRIST",160,80)  
        else:
            return  PoseDetector(0,"LEFT_SHOULDER","LEFT_ELBOW","LEFT_WRIST",160,60)        
    pass
   

@views.route('/')
@login_required
def home():
   
          
    # sessionUser = SessionUser.query.filter_by(id_user=current_user.id, fini=False).all()
    q = db.session.query(
         SessionUser, SessionMeta, Entrainement
        ).join(User
               ).filter(
            User.id == SessionUser.id_user
            ).filter(
                SessionMeta.id_session == SessionUser.id
                ).filter(
                    Entrainement.id == SessionUser.id_entrainement
                    ).filter(
                        User.id == current_user.id,
                        SessionUser.fini == False
                        ).all()
    
    
    return render_template("home.html", user=current_user, information_user=q)



    """
    ici je tourne en boucle ma video 
    """
def gen(camera):
    condition = True
    while condition:
        frame = camera.get_frame()
        yield(b'--frame\r\n'
              b'Content-Type: image/jpeg\r\n\r\n'+ frame + b'\r\n\r\n')
        # if camera.getCounter() == camera.getNbrRepetition():       
        #     camera.setIsTerminate(True)
        if camera.getCounter() == camera.getNbrRepetition():       
            camera.setIsTerminate(True)

"""
    cette méthode me permet d'envoyer mon flux video dans une balise image que j'ai dans
    un template
"""
@views.route('/start-video', methods=['POST'])
def start_video():
    if request.method == 'POST':
        
        q = db.session.query(
            SessionUser, SessionMeta, Entrainement
                ).join(User
                    ).filter(
                    User.id == SessionUser.id_user
                    ).filter(
                        SessionMeta.id_session == SessionUser.id
                        ).filter(
                            Entrainement.id == SessionUser.id_entrainement
                            ).filter(
                                User.id == current_user.id,
                                SessionUser.fini == False
                                ).all()
        
        for row in q:
            
            if int(row[1].meta_value) == int(request.form.get('nombre_repetition')):
                data = {
                    'nombre_repetition' : row[1].meta_value,
                    'nom': row[2].nom,
                    'session_id' : row[0].id
                }
                print(data)
                # ici je lance ma camera et j'ini les exo
                global camera
                camera  = exercice(row[2].nom, row[2].niveau )
                print(f"global camera {camera}")
                return run_video(data)
            else:
                flash('mauvaises valeurs', category="error")
    return redirect(url_for('views.home'))

@views.route('/enregistrement')
def enregistrement():
    camera.__del__()
    return redirect(url_for('views.home'))

# la page où la vidéo se lance 
def run_video(data):
    #je compte les répétitions ici
    camera.setCounter(0)
    camera.setNbrRepetition(data['nombre_repetition'])
    
    return render_template('entrainement.html', user=current_user, data=data)


@views.route('/stop-video')
def stop_video():
    camera.__del__()
    return redirect(url_for('views.home'))



@views.route('/video')
@login_required
def video():

    return Response(gen(camera),
                    mimetype='multipart/x-mixed-replace; boundary=frame')
    

#ici je sauvegarde mes données dans ma db
@views.route('/save-exercice', methods=["POST"])
def save_exercice():
    if request.method =='POST':

        commentaire = request.form.get('formulaire')
        request_session = SessionUser.query.get(request.form.get('session_id'))
        if request_session == None:
            flash("Ne modifiez aucune donnée !", category="error") 

        elif len(commentaire ) <= 0:
            flash("le champ commentaire ne peut pas être vide.", category="error") 
        else:
            flash('Entraînement fini !', category="success")
            #ici je fais ma requêt pour sauvegarder mes exercices.
            request_session.fini = True
            request_session.message_user = commentaire
            request_session.repetition_fait = camera.getCounter()
            request_user = User.query.get(current_user.id)
            request_user.seance_restante -= 1
            db.session.commit()
            return stop_video()
    return resultat()
    
    #ici  on arrive sur la page résultat et je récupère les répétitions fais.
@views.route('/resultat', methods=["POST"])
@login_required
def resultat():
    
    data = {
        'repetition_fait': camera.getCounter(),
        'nombre_repetition_a_faire' : camera.getNbrRepetition(),
        'session_id'  : request.form.get('session_id')
    }
    camera.setIsTerminate(True)
    return render_template('resultat.html', user=current_user, data = data)