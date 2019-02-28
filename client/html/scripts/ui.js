let keyFobKey;

// Callback to client.lua
function httpPost(event, data) {
    const xhr = new XMLHttpRequest(); 
    xhr.open("POST", "http://esx_locksystem/" + event, true); //FIXME: true=async you may need to set this both ways. it may help with timing.
    xhr.send(JSON.stringify({data}));
}

document.onkeydown = function (data) {
    if (data.which == '42' || '27') { // Escape key 
        document.getElementById("keyfob").style.display = 'none';
        document.getElementById("carDisconnected").style.display = 'none';
        document.getElementById("carConnected").style.display = 'none';
        document.getElementById("engineOff").style.display = 'none';
        document.getElementById("engineOn").style.display = 'none';
        document.getElementById("unlocked").style.display = 'none';
        document.getElementById("locked").style.display = 'none';
        httpPost("NUIFocusOff");
    }
};


// Listens for messages from the client and updates the status
window.addEventListener('message', function(event) {

    // Open Key Fob
    if (event.data.type == "openKeyFob") {
        document.getElementById("keyfob").style.display = 'block';
        
    } else if (event.data.type == "keyFobKey") {

    
    } else if (event.data.type == "carConnected") {
        document.getElementById("carDisconnected").style.display = 'none';
        document.getElementById("carConnected").style.display = 'block';
    
    } else if (event.data.type == "carDisconnected") {
        document.getElementById("carConnected").style.display = 'none';
        document.getElementById("carDisconnected").style.display = 'block';
        document.getElementById("engineOff").style.display = 'block';
        document.getElementById("unlocked").style.display = 'block';       
    
    } else if (event.data.type == "engineOn") {
        document.getElementById("engineOn").style.display = 'block';
        document.getElementById("engineOff").style.display = 'none';
    
    } else if (event.data.type == "engineOff") {
        document.getElementById("engineOn").style.display = 'none';
        document.getElementById("engineOff").style.display = 'block';
    
    } else if (event.data.type == "locked") {
        document.getElementById("unlocked").style.display = 'none';
        document.getElementById("locked").style.display = 'block';

    } else if (event.data.type == "unlocked") {
        document.getElementById("unlocked").style.display = 'block';
        document.getElementById("locked").style.display = 'none';
// FIXME: NOT WORKING BELOW        
    } else if (event.data.type == "disableButtons") {
        document.getElementById("buttonStart").disabled = true;
        document.getElementById("buttonLock").disabled = true;
        document.getElementById("buttonUnlocked").disabled = true;
        document.getElementById("buttonAux").disabled = true;
        
    } else if (event.data.type == "enableButtons") {
        document.getElementById("buttonStart").disabled = false;
        document.getElementById("buttonLock").disabled = false;
        document.getElementById("buttonUnlocked").disabled = false;
        document.getElementById("buttonAux").disabled = true;

// FIXME: NOT WORKING ABOVE        
    } else if (event.data.type == "closeAll") {
        document.getElementById("keyfob").style.display = 'none';
        document.getElementById("carDisconnected").style.display = 'none';
        document.getElementById("carConnected").style.display = 'none';
        document.getElementById("engineOff").style.display = 'none';
        document.getElementById("engineOn").style.display = 'none';
        document.getElementById("unlocked").style.display = 'none';
        document.getElementById("locked").style.display = 'none';
        httpPost("NUIFocusOff");
    }


});