import cv2
import mediapipe as mp
import numpy as np
import winsound
import time
frequency = 1000  # Set Frequency To 2500 Hertz
duration = 100  # Set Duration To 1000 ms == 1 second
#pour que le script fonctionne je dois montrer mon côté droit à la caméra

class PoseDetector(object):
   
 
    def __init__(self, path, haut ,milieu, bas, angle_down , angle_up):
        self.video = cv2.VideoCapture(path)
        self.counter = 0
        self.etat = None
        self.stage = 0
        self.condition = (0,0,170)
        self.information = None
        self.mp_drawing = mp.solutions.drawing_utils
        self.mp_pose = mp.solutions.pose
        self.pose = self.mp_pose.Pose()
        self.isRunning = True
        self.previous_time = 0
        self.nbr_repetition = 0
        self.isTerminate= False
        self.haut = haut
        self.milieu = milieu
        self.bas = bas
        self.angle_down = angle_down
        self.angle_up = angle_up

    def setNbrRepetition(self,nbr):
        self.nbr_repetition = nbr
    
    def getNbrRepetition(self):
        return self.nbr_repetition
    
    def setHello(self,x):
        self.hello = x
    
    def setIsTerminate(self,value):
        self.isTerminate = value
        
    def setIsRunning(self,value):
        self.isRunning = value
    
    def getIsTerminate(self):
        return self.isTerminate
    
    def getIsRunning(self):
        return self.isRunning
    
    def __del__(self):
        self.isRunning=  False
        self.video.release()
        
    
    def setCounter(self,ctx):
        self.counter = ctx
        
    def getCounter(self):
        return self.counter
        
    # le calcule de l'angle est bon !
    def calculate_angle(self,a,b,c):
        a = np.array(a) # First
        b = np.array(b) # Mid
        c = np.array(c) # End
                
        radians = np.arctan2(c[1]-b[1], c[0]-b[0]) - np.arctan2(a[1]-b[1], a[0]-b[0])
        angle = np.abs(radians*180.0/np.pi)
            
        if angle >180.0:
            angle = 360-angle         
        return angle
    
    def run(self,**kwargs):
        while self.isRunning:
            self.get_frame(down = kwargs['down'], up = kwargs['up'])
            if(self.getCounter() == 1):
                self.setIsTerminate(True)
                  # True = continue | False = Stop
            if cv2.waitKey(10) & 0xFF == ord('q'):
                break            
    # je lance la vidéo
    
    
    def get_frame(self,**kwargs):
                
                
                ret, frame = self.video.read()
                moment = time.time()
                # Recolor image to RGB
                image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                image.flags.writeable = False
            
                # Make detection
                results = self.pose.process(image)
            
                # Recolor back to BGR
                image.flags.writeable = True
                image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
                
                
                #je compte les secondes ici 
       
                
                
                
                # Extract landmarks
                try:
                    landmarks = results.pose_landmarks.landmark
                    
                   
                    #je récupére les x,y de la hanche,genoux et cheville
                    haut = [landmarks[self.mp_pose.PoseLandmark[self.haut].value].x,landmarks[self.mp_pose.PoseLandmark[self.haut].value].y]
                    milieu = [landmarks[self.mp_pose.PoseLandmark[self.milieu].value].x,landmarks[self.mp_pose.PoseLandmark[self.milieu].value].y]
                    bas = [landmarks[self.mp_pose.PoseLandmark[self.bas].value].x,landmarks[self.mp_pose.PoseLandmark[self.bas].value].y]

                 
                
                    # Calculate angle
                    # HAUT MILIEU BAS
                    
                    angle = self.calculate_angle(haut, milieu, bas)

                    cv2.putText(image, str(angle), 
                           tuple(np.multiply(haut, [640, 480]).astype(int)), 
                           cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2, cv2.LINE_AA
                                )

                    
                    
                    
                
        
                    #  get_frame(down .. , up ..)
                    # if self.isTerminate == False:
                    #     if angle > kwargs['down']:
                    #         self.stage = "down"
                    #         self.condition = (0,0,170)
                
                        
                    # if angle < kwargs['up'] and self.stage == "down":
                    #     self.stage="up"
                    #     self.condition = (0,252,124) #ici j'affiche la couleur
                    #     self.counter += 1
                    #     winsound.Beep(frequency, duration)
                    #     cv2.rectangle(image, (10,80), (200,100), self.condition, -1)
                                        

                    if self.isTerminate == False:
                        if angle > self.angle_down:
                            self.stage = "down"
                            self.condition = (0,0,170)
                
                        
                    if angle < self.angle_up and self.stage == "down":
                        self.stage="up"
                        self.condition = (0,252,124) #ici j'affiche la couleur
                        self.counter += 1
                        winsound.Beep(frequency, duration)
                    cv2.rectangle(image, (10,80), (200,100), self.condition, -1)                   
          
                        
               
                    
                except:
                    pass
                
                
                if self.isTerminate == False:         
                    cv2.putText(image, 'REPS', (15,12), 
                                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0,0,0), 1, cv2.LINE_AA)
                    
                      
                    cv2.putText(image, str(self.counter), 
                                (10,60), 
                                cv2.FONT_HERSHEY_SIMPLEX, 2, (255,255,255), 2, cv2.LINE_AA)
                    

                    
                    # l'action en bas ou en haut
                    cv2.putText(image, 'ACTION', (100,12), 
                                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0,0,0), 1, cv2.LINE_AA)
                    cv2.putText(image, str(self.stage), 
                                (100,60), 
                                cv2.FONT_HERSHEY_SIMPLEX, 2, (255,255,255), 2, cv2.LINE_AA)
                    #nombre de répétition
                    cv2.putText(image, 'NOMBRE', (300,12), 
                                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0,0,0), 1, cv2.LINE_AA)  
                                
                
                    cv2.putText(image, str(self.nbr_repetition), 
                                (300,60), 
                                cv2.FONT_HERSHEY_SIMPLEX, 2, (255,255,255), 2, cv2.LINE_AA)                

                    # Render detections
                    self.mp_drawing.draw_landmarks(image, results.pose_landmarks, self.mp_pose.POSE_CONNECTIONS,
                                        self.mp_drawing.DrawingSpec(color=(0,0,255), thickness=2, circle_radius=2), 
                                            self.mp_drawing.DrawingSpec(color=(67,246,109), thickness=2, circle_radius=2) 
                                            )               
                elif self.isTerminate == True:
                   cv2.putText(image, 'TERMINE', 
                                (60,60), 
                                cv2.FONT_HERSHEY_SIMPLEX, 2, (255,255,255), 2, cv2.LINE_AA)
                    
                         
                # cv2.imshow('Mediapipe Feed', image)
               
                # pour renvoyer à la balise img on retourne une frame
                frame = cv2.imencode('.jpg', image)[1].tobytes()
                return frame
        
     
class PoidsDuBras(PoseDetector):
    def __init__(self,path,haut,bas,milieu, angle_down , angle_up):
        PoseDetector.__init__(self,path,haut,bas,milieu, angle_down , angle_up)
        
      
          

# video = PoidsDuBras(0,"LEFT_HIP","LEFT_KNEE","LEFT_ANKLE")
# video.run(down=160,up=140)