module detectSSHTELNET;

const telnet_ports = { 23/tcp };


global login_success_msgs: set [string] &redef;
global login_failure_msgs: set [string] &redef;
global login_prompts: set[string] &redef;

global readyForLogin: bool;

export{
    redef enum Notice::Type += {
        TELNET_LOGIN,
        SSH_LOGIN,
    };
}



function start_analyzers(){
    Analyzer::register_for_ports(Analyzer::ANALYZER_TELNET, telnet_ports);
}


event zeek_init(){
    start_analyzers();
    readyForLogin = F;
}

event ssh_auth_attempted(c: connection, auth_method_none: bool){
    if(c$id$orig_h != 192.168.1.2 && c$id$resp_h != 192.168.1.2){
        NOTICE([$note=SSH_LOGIN, $conn=c,
            $msg = "ssh attempt"]);
    }
}


event ssh_auth_successful(c: connection, auth_method_none: bool){
    if(c$id$orig_h != 192.168.1.2 && c$id$resp_h != 192.168.1.2){
        NOTICE([$note=SSH_LOGIN, $conn=c,
            $msg = "ssh successful"]);
    }
}


event login_success(c: connection, user: string, client_user: string, password: string, line: string){
#    print c;
    if(c$id$orig_h != 192.168.1.2 && c$id$resp_h != 192.168.1.2){
        NOTICE([$note=TELNET_LOGIN, $conn=c,
            $msg = "telnet successful"]);
    }
}


event login_failure(c: connection, user: string, client_user: string, password: string, line: string){
    if(c$id$orig_h != 192.168.1.2 && c$id$resp_h != 192.168.1.2){
        NOTICE([$note=TELNET_LOGIN, $conn=c,
            $msg = "telnet fail"]);
    }
}


event login_prompt(c: connection, line: string){
    if(c$id$orig_h != 192.168.1.2 && c$id$resp_h != 192.168.1.2){
        NOTICE([$note=TELNET_LOGIN, $conn=c,
            $msg = "telnet prompt"]);
    }
}


event authentication_accept(c: connection, line: string){
    if(c$id$orig_h != 192.168.1.2 && c$id$resp_h != 192.168.1.2){
        NOTICE([$note=TELNET_LOGIN, $conn=c,
            $msg = "telnet auth successful"]);
    }
}


event authentication_rejected(name: string, c: connection){
    if(c$id$orig_h != 192.168.1.2 && c$id$resp_h != 192.168.1.2){
        NOTICE([$note=TELNET_LOGIN, $conn=c,
            $msg = "telnet auth unsuccessful"]);
    }
}


event login_confused(c: connection, msg: string, line: string){
    if(c$id$orig_h != 192.168.1.2 && c$id$resp_h != 192.168.1.2){
        NOTICE([$note=TELNET_LOGIN, $conn=c,
            $msg = "telnet confused"]);
    }
    
}


event login_input_line(c: connection, line: string){
    print line;
    if(c$id$orig_h != 192.168.1.2 && c$id$resp_h != 192.168.1.2){
        NOTICE([$note=TELNET_LOGIN, $conn=c,
            $msg = "telnet input"]);
    }

}


event login_output_line(c: connection, line: string){   
    print line;
    if("Login incorrect" in line){
        if(c$id$orig_h != 192.168.1.2 && c$id$resp_h != 192.168.1.2){
            NOTICE([$note=TELNET_LOGIN, $conn=c,
                $msg = "telnet fail"]);
        }
    }
    if("Password" in line){
        readyForLogin = T;
    }
    if("#" in line){
        if(readyForLogin == T){
            NOTICE([$note=TELNET_LOGIN, $conn=c,
                $msg = "telnet successful"]);
            readyForLogin = F;
        }
    }
}

