function startEntrainement(id_user,nbr_repetition,id_entrainement){

    fetch(`${window.origin}/start-video`,{

        method:'POST',
        credentials: 'include',
        cache : 'no-cache',
        body: JSON.stringify({id_user : id_user, nbr_repetition: nbr_repetition, id_entrainement: id_entrainement}),
        headers : new Headers(
            {'content-type':"application/json"}
        )
    }
    ).then(
        function(response){
            if(response.status !==200){
                console.log("erreur ")
            }
            response.json().then(
                function(data){
                    console.log(data)
                    
                }
            ).catch(function(err){
                console.log(err)
            })
        }
    ).catch(function(err)
    {
        console.log(err)
    })
   

}



function enregistrementEntrainement(id_user,id_session){

    fetch(`${window.origin}/enregistrement`,{

        method:'POST',
        credentials: 'include',
        cache : 'no-cache',
        body: JSON.stringify({id_user : id_user, id_session: id_session}),
        headers : new Headers(
            {'content-type':"application/json"}
        )
    }
    ).then(
        function(response){
            if(response.status !==200){
                console.log("erreur ")
            }
            response.json().then(
                function(data){
                    console.log(data)
                    
                }
            ).catch(function(err){
                console.log(err)
            })
        }
    ).catch(function(err)
    {
        console.log(err)
    })
   

}

