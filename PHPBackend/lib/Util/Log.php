<?php
namespace Util;

class Log {
    
    static function printRToErrorLog ($e){
    
        if ( defined ('DISABLE_U_PRINT_LOG')) {
            
            if ( DISABLE_U_PRINT_LOG ){
                return ;
            }
        
        }
        
        ob_start ();
        
        print_r($e);
        
        $c= ob_get_contents();
        ob_end_clean();
        
        error_log($c);
    }

}
?>
