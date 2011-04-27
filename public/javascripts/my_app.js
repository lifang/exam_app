function check(){
	var name=document.getElementById("user_name").value;
	var strEmail=document.getElementById("user_email").value;
	var password=document.getElementById("user_password").value;
	var confirmation=document.getElementById("user_password_confirmation").value;
	var myReg =new RegExp(/^\w+([-+.])*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/);
	var check_value = new RegExp(/[a-z0-9_]/g);
	var strEmail=document.getElementById("user_email").value;
        
         if (name == null || name.length ==0||name.length>20){
				document.getElementById("nameErr").innerHTML="<font color = 'red'>用户名不能为空，长度不能超过20</font>";
				return false;
		 }else{



			if (check_value.test(name)) {

					if (strEmail == null || strEmail.length ==0||strEmail.length>50){
							document.getElementById("emailErr").innerHTML="<font color = 'red'>邮箱不能为空，长度不能超过50</font>";
							return false;
					} else {



						   if ( myReg.test(strEmail)) {

								if (password == null || password.length ==0||password.length>40||password.length<6){

									document.getElementById("passwordErr").innerHTML="<font color = 'red'>密码不能为空，长度在6和20之间</font>";
									return false;
								} else	{
									   if (confirmation != password){

											document.getElementById("confirmationErr").innerHTML="<font color = 'red'>两次输入的密码不一致，请重新输入</font>";
											return false;
										}else
											return true;
								}
							} else
									document.getElementById("emailErr").innerHTML="<font color = 'red'>邮箱格式不对，请重新输入！</font>";
									return false;
					}

			} else
					document.getElementById("nameErr").innerHTML="<font color = 'red'>用户名只能由字母，数字和下划线组成</font>";
					return ;
		}

 }
