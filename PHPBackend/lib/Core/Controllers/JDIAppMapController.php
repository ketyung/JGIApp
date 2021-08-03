<?php
namespace Core\Controllers;

use Core\Db\JDIAppUser as User;
use Core\Db\JDIAppMap as Map;
use Core\Db\JDIAppMapVersion as MapVersion;
use Core\Db\JDIAppMapVersionNote as MapNote;
use Core\Db\JDIAppMapVersionItem as VersionItem;
use Core\Db\JDIAppMapVersionIpoint as VersionIpoint;
use Core\Controllers\RequestMethod as RM;
use Core\Controllers\Controller as Controller;
use Util\Log as Log;

class JDIAppMapController extends Controller {
    
    protected function createDbObject(){
        
        $this->dbObject = new Map($this->db);
    }
    
    protected function getDbObjects(){
        
        $param1 = "";
        $param2 = "";
        $param3 = "";
        
        
       // Log::printRToErrorLog($this->params);
       
        if (isset($this->params)) {
            
            if (isset($this->params[0])){
                $param1 = $this->params[0];
            }
            
            if (isset($this->params[1])){
                $param2 = $this->params[1] ;
            }

            if (isset($this->params[2])){
                $param3 = $this->params[2] ;
            }
          

        }
        
        if ($param1 == 'user' && $param2 != '' ){
        
            return $this->getByUserId($param2);
        }
        else
        if ($param1 == 'id' && $param2 != '' ){
        
            return $this->getBy($param2, $param3);
        }

        else {
         
            return $this->notFoundResponse();
        }
        
    
    }
    

    private function getBy($id, $version_no){
        
        $pk = array('id'=>$id);

        if ($this->dbObject->findByPK($pk)){

            
            $response['status_code_header'] = 'HTTP/1.1 200 OK';
            $response['body'] = json_encode($result);
            return $response;
           
        }
        else {
            
            return $this->notFoundResponse();
        }
        
    }
    


    
    private function getByUserId($userId){
        
        $result = $this->dbObject->findByUserId($userId) ;
        
        if (count($result) > 0){
       
            $response['status_code_header'] = 'HTTP/1.1 200 OK';
            $response['body'] = json_encode($result);
            return $response;
           
        }
        else {
            
            return $this->notFoundResponse();
        }
        
    }
    
    
    
    function notifyOfMoneySent(Array $paymentTx){
        
        $input = array();
        $input['uid'] = $paymentTx['to_uid'];
        $input['item_id'] = $paymentTx['id'];
       
        $user = new User($this->db);
        
        $pk['id'] = $paymentTx['uid'];
        
        
        $userName = "Someone";
        if ($user->findByPK($pk)){
            $userName = $user->firstName . " ".$user->lastName;
        }
        /**
        Log::printRToErrorLog($pk);
        Log::printRToErrorLog($user);*/
        /**
        if ( $paymentTx['tx_type'] == 'SM') {
            
            $input['title'] = "Money Received!";
            $input['sub_title'] = $userName . " sent you money ". $paymentTx['currency'].' '.abs( $paymentTx['amount'] );
        }
        else
        if ( $paymentTx['tx_type'] == 'WT') {
            
            $input['title'] = "Wallet Top-up!";
            $input['sub_title'] =  "Top-up for wallet ". $paymentTx['currency'].' '.abs( $paymentTx['amount'] );
        }
        else {
            
            $input['title'] = "Money Received!";
            $input['sub_title'] = $userName . " sent you money ". $paymentTx['currency'].' '.abs( $paymentTx['amount'] );
       
        }
        
        $input['type'] =  $paymentTx['tx_type'] ;
         */
       
        $input['title'] = "Money Received!";
        $input['sub_title'] = $userName . " sent you money ". $paymentTx['currency'].' '.abs( $paymentTx['amount'] );
        $input['type'] =  'SM' ;
   
        $mesg = new Message($this->db);
        $mesg->insert($input);
        
    }
    
}

?>