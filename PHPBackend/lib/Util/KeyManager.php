<?php
namespace Util;

class KeyManager {
    
    private static function generateNonceArray($num = 30) {

        $astr = 'array(';
        
        for( $i = 0; $i < $num; $i++){
            
            $key = base64_encode (random_bytes(SODIUM_CRYPTO_SECRETBOX_NONCEBYTES));
            $astr.= ($i < ($num -1)) ? '"'.$key.'",' : '"'.$key.'"';
        
        }
        
        $astr.=')';
        
        return $astr;
        
    }
    
    

	private static function generateKeyArray($num = 30) {

		$astr = 'array(';
		
		for( $i = 0; $i < $num; $i++){
			
			$key = base64_encode (random_bytes(SODIUM_CRYPTO_SECRETBOX_KEYBYTES));
			$astr.= ($i < ($num -1)) ? '"'.$key.'",' : '"'.$key.'"';
		
		}
		
		$astr.=')';
		
		return $astr;
		
	}
	
	
	static function key(&$seed, $toDecode = false ){
		
		$keys = self::keys();
		
		if (!is_numeric($seed)){	
			$seed = rand(0, count($keys) - 1);
		}
		
		$key =  $keys[$seed] ?? "VV1rNszKFbfIqkttqscNZ7Z+elKziJpp4JkGFGDsRnE=" ;
		
		if ($toDecode){
			
			return base64_decode($key);	
		}
		
		return $key;
	}
    
    
    static function nonce(&$seed, $toDecode = false ){
        
        $nonces = self::nonces();
        
        if (!is_numeric($seed)){
            $seed = rand(0, count($nonces) - 1);
        }
        
        $nonce =  $nonces[$seed] ?? "RZichM1sAPrYTn4WFmvsBelThLl1S09m";
        
        if ($toDecode){
            
            return base64_decode($nonce);
        }
        
        return $nonce;
    }
	
	
	
	
    static function nonces() {
        
        return array("YTcQ/LqH/yUVlPrWMRCOrAweNY/2taq8","hArPte2R5lMFE6BhW016IgeCOzOlMhpT","gGHoMZti3/7zzSH9GqTmPNYd6pwcVPTl","74HRkiOVi3EPpiUHZEhyHcnFfSRSpejm","RZichM1sAPrYTn4WFmvsBelThLl1S09m","PScI4cLdrhiPixqgdTqwEC/R6+STKiso","+VoWhDGyvoMbcngGjhD8UG+8M0lV4f8l","mMajH/DBnRl1aH1aawM0BvL56FF55Bwf","FQ6VlcNn220n0H3kCelLXAK0Pju+tcj1","lG2WnxvoEsaBiGNnzPZHJQYtVslUEXG7","DEv6aVXVz0ZoXm6mYuOAGTIITz+Y5jla","fFuKTN2VkNnlasKkUK89wT6FRfg/FjcL","XUrf5/ZH6Bc8w9ewB1gXoR0LEf2dVfGB","rINOEI/h+JwLcYDmiRy635hXuBoXYI/B","l3qRcX0/FNhGob6u+MIATs6rakxx0C3b","ZqppCyMx5zNNygU9IPU4LRX41wkb3QBu","HBBFC1BgFbmgtRE5SliSBaGBK/Iq9ZNV","cbcOnYrKhI45OZqOrgE1k2LZSfn7t9OO","v6iqPaE1H2X0LMmCA+TUZh2Ua44kfL3U","T6wI4+/Agwahs0o/6L7HadCphg+lyrFs","XaPPW4vxGZQ1AeZ7q6IULm6gmXqEElVb","LzX2TUDz9Fdz8Fs32OCKp3NyZmS6skAE","mss2wmjyOfhVlPUb/1ng4i0o5PwhEu2H","feZLtjhzyVlo52jMxb8HYDpg35y0L9is","pSqsHcjZNTfCX0fQcvts+2OzF8oRI3/k","KFNYLpdbRC4hfPULBKfXpO7QJMOSf39t","S5ENREqf2ZPlPqg7SETKTXw+ia7XDeWF","tCnWEoZPMG3ko239Ir9Co3dhoOlFdApF","rdN+wb/GffbOeP4yrhAa+Xu2HaBy3JAm","BhQFfzjPSwA7RpFazYCn0uzIQRhVx4qR");

        
    }
	
	static function keys(){
	
		return array("WlJzS7kpNM7gkAO0OUYCLYrPR6tztnGmYfm8PNrjIO0=","X0zhGOKSHXQn1g2k7fpxEtNmQzSUR3sV4QqI/9/vuUw=","xgCP9Ba7Srzc7Vs879K/BV4+6D5HYltBPjXHzZgvKIA=","66hCH9b/RDyvdXSkAUnOFf/2ZVMtHTXyWqhYURUZ4bQ=","gjY67ds5kUbmKG6LUgr2hyK4cSgHJjSub//W23lBHkA=","2iVXjFvGc4szfLvFrNScEsSv6RPXV8G36uWBfrxo0nk=","/2DrBQ1BallrG0Ii67bPKD0GB1W1CnkuuitvcduWJwc=","OXhJlniPOFlNbt06FbrNOwMPSV9bApUQb5RJlJ7p/Bc=","cl0e0de5Y80HxdCEdVZSQZ5wF7/31vUMCnI/yXbAjjg=","H3cENBx9VqgJwxZB1VEbMiJumooRJ2R9oprCfz4LNY8=","C/7OwOqHsGWj58BqxTVxhi3DqQaJ/ttlH3hGon1v2h0=","jHPjljAeBWtXzvf1SwZfG5RnX0zUQVr+C4RJ6NlfEoo=","Ob1FCbhLDDeLnRqD3Up2hTNHun/mV4IRCIg450R7FRE=","LouQiaMStKnntR9NHN/Dr60fikmBovK7PP/9mdM3F8I=","5Cbv8q+CWv0e7j/fK2F4/j9Yz9/zcc14FZ0PEARjlIY=","0RJWhsddOk0pnQSAPYnRZDlRZD/cVEDb58vCzqBrI9E=","egaD93eDebCjsCPJZFrqFoyQVQ+qRXUkaoB/JjETbjg=","IyqHRP9P8RmqBi+XU56mJaNcKhMs2UbR1s+j+pPaD+8=","m2U5wl5zveE+GEL1lSc0BGCL8gIdsPXRXB5xieSSTwg=","l7i8WJQYTQ9GngXi7MXq4sT3kMlu0tkFujpYghW5O2c=","YxlZcaejhe7gLrrwg1AayBMKrh37YfQPjFPK6hbzYUM=","ZQkG34yMMBB89G9GXst5KNGDrAA5Xp5y+uOWerfC2bM=","gVj5w/t4zGj/qquJK9Bzg+ej1UFc2CiTUKP8zTztDik=","VV1rNszKFbfIqkttqscNZ7Z+elKziJpp4JkGFGDsRnE=","aj1PegAC6FNQg/pbJA0fRdmUP33eUYM0GZEMyfYBLmI=","uJ4aF2St0v5zIANAUs4fjCX86LG8Aq9potgyXJw1i5Y=","4BAzosGh93NjJVwKWBWmropWm3eylXObc3L3iQvaf84=","2r7DXzuvMFwQSHuzjwzR3l+vGzBDleDhhsUXTk5q/K0=","HJK1/+UXJ8pIE0lATpnDbRGwFxijfJENn4KLlA1ydis=","GQ7NAwKTFwCeAbvadUG6h1qb7j6fjbS/Igy5uyZlZtk=");

	}
	
}


?>
