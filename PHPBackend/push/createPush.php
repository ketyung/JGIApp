<?php
define('BUNDLE_ID','com.techchee.swiftui.tut.JGIAppApp2');

pushToSim();

function pushToSim($payLoadFile = "payload.json", $log = "push.log"){
    
    $xcrun = exec('which xcrun');
    
    $cmd = "$xcrun simctl push booted ".BUNDLE_ID." $payLoadFile > $log 2>&1 & echo $!;";
    
    $rt=exec($cmd, $op, $r);
    
    echo "executed $r \n";
}
?>
