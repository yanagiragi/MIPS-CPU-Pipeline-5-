.data
.text
.globl main

# int gcd(int a,int b){
#	  
#     while(a > 0)
#     {
#		  if(a < b) swap(a,b);
#         tmp = a;
#         a = b-a;
#         b = tmp;
#     }
#     return b;
#}

main:
									#gcd(a,b) -> gcd($t0,$t1) $t2 for tmp
	    li 		$t0,0				# constant 0							
	    li		$t1,1 				# constant 1
	    li		$t3,120				# Var 1, always the bigger
	    li		$t4,72				# Var 2, always the smaller

	    #lw 	$t0,0($sp)			# No need
	    #lw		$t1,1($sp)			# 100011_00001_00001_00000_00000_000000
	    #lw		$t3,3($sp)			# 100011_00011_00011_00000_00000_000000
	    #lw		$t4,4($sp)			# 100011_00100_00100_00000_00000_000000
gcd2:
	    slt		$t2,$t3,$t4 		# 000000_00011_00100_00010_00000_101010
	    beq     $t2,$zero,gcd 		# 000100_00010_00000_00000_00000_000000 // not add addr
	    			
	    sw      $t3,0($sp)			# 101011_00000_00011_00000_00000_000000
	    add		$t3,$t4,$t0 		# 000000_00011_00100_00000_00000_100000
	    lw 		$t4,0($sp)			# 100011_00000_00100_00000_00000_000000
      
gcd :  	
	    sub		$t3,$t3,$t4			# 000000_00011_00100_00011_00000_100010
        slt		$t2,$t4,$t1			# 000000_00100_00001_00010_00000_101010
       	beq     $t2,$zero,gcd2		# 000100_00010_00000_00000_00000_000000 // not add addr

       	j		$ra					# result = t3

  