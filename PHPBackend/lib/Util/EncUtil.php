<?php
namespace Util;

class EncUtil {
	

	static function encrypt($plainText, &$key = null, $nonce = null ){
	
        
        try {
            
           // $caller = debug_backtrace()[1]['function'] ?? "none";
           //error_log("caller::: $caller"  );
            
            if (!isset($key)) {
                
                $key = random_bytes(SODIUM_CRYPTO_SECRETBOX_KEYBYTES);
            }
            
            if (!isset($nonce)){
        
                $nonce = random_bytes(SODIUM_CRYPTO_SECRETBOX_NONCEBYTES);
            
            }
        
            $ciphertext = sodium_crypto_secretbox($plainText, $nonce, $key);
        
            $ciphertext = base64_encode($nonce . $ciphertext);
        
            return $ciphertext;
            
        }
        catch(\SodiumException $e){
            
            error_log("SodiumException : ".$e->getMessage());
            return null;
        }
       
	}
	
	
	static function decrypt($ciphertext, $key, $nonce = null ) {
		
        
        try {
            
       
           // $caller = debug_backtrace()[1]['function'] ?? "none";
            //error_log("caller::: $caller"  );
           
            
            $decoded = base64_decode($ciphertext);
            
            if (!isset($nonce)) {
           
                $nonce = mb_substr($decoded, 0, SODIUM_CRYPTO_SECRETBOX_NONCEBYTES, '8bit');
            }
            
            $cipherText = mb_substr($decoded, SODIUM_CRYPTO_SECRETBOX_NONCEBYTES, null, '8bit');
        
            $plaintext = sodium_crypto_secretbox_open($cipherText, $nonce, $key);
        
            return $plaintext;
        }
        catch(\SodiumException $e){
            
            error_log("SodiumException : ".$e->getMessage());
            return null;
        }
	}
	
	
	static function randomString(int $length = 6){
	
		$bytes = random_bytes($length);
		return base64_encode($bytes);
		
	}
	
}
?>
