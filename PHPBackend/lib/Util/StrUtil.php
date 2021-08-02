<?php
namespace Util;

class StrUtil {
    
    static function snakeToCamelCase($string, $capitalizeFirstCharacter = false)
    {

        $str = str_replace(' ', '', ucwords(str_replace('_', ' ', $string)));

        if (!$capitalizeFirstCharacter) {
            $str[0] = strtolower($str[0]);
        }

        return $str;
    }
    
    
    static function camelToSnakeCase($input) {
     
       $pattern = '!([A-Z][A-Z0-9]*(?=$|[A-Z][a-z0-9])|[A-Za-z][a-z0-9]+)!';
       preg_match_all($pattern, $input, $matches);
       
       $ret = $matches[0];
       foreach ($ret as &$match) {
           $match = $match == strtoupper($match) ? strtolower($match) : lcfirst($match);
       }
       return implode('_', $ret);
    }
           
           
    static function arrayKeysToSnakeCase(Array &$input){
        
        $keys = array_keys($input);
        foreach ( $keys as $key ){
            
            $val = $input[$key];
         
            unset($input[$key]);
         
            $skey = self::camelToSnakeCase($key);
            
            $input[$skey] = $val;
            
        }
        
    }
           
    static function snakeCaseToWords($str){
        
        $f = ucwords($str, "_");
        
        $f = str_replace("_", " ", $f);
      
        return $f;
    }
           
    static function escapeBase64($input) {
        $s =  bin2hex('+').bin2hex('/').bin2hex('=').bin2hex("\\");
        return strtr($input, '+/='."\\", $s);
    }
           
    static function startsWith($string, $word ){
        
        return substr( $word, 0, strlen($word) ) == $word ;
        
    }
           
}
?>
