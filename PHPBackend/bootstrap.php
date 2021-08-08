<?php
require_once __DIR__."/lib/Db/SQLBuilder.php";
require_once_in("/lib/Util");
require_once_in("/lib/Db");
require_once_in("/lib/Core/Controllers");

require_once __DIR__."/lib/Core/Db/JGIAppDbObject.php";
require_once_in("/lib/Core/Db");
require_once __DIR__."/vendor/autoload.php";

define('IMAGE_URL_PREFIX', 'http://127.0.0.1:808/TzBackend/images');

// Use this for remote one
// define('IMAGE_URL_PREFIX', 'https://techchee.com/ximages');


//header("Content-type:text/plain");

function require_once_in($dir, $excludes = array(__DIR__.'/lib/Db/SQLBuilder.php', __DIR__.'/lib/Core/Db/JGIAppDbObject.php')){

   $dir = __DIR__.$dir;
    
   foreach (scandir($dir) as $filename)  {
        $path = $dir . '/' . $filename;
       
        $file_parts = pathinfo($path);
       
        if (is_file($path) && !in_array($path, $excludes) && $file_parts['extension'] == 'php') {
            
        //   echo $path."\n";
           require_once $path;
        }
    }
}
?>
