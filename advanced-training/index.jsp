<%@ page contentType="text/html;charset=gb2312" 
language="java" import="java.util.*,java.sql.*"%>
<!--��Ҫ����ѧ����ѧ��(keyΪsid)-->
<!DOCTYPE html>
<% 
		request.setCharacterEncoding("gb2312");				
		String select="";				
		String filter_state="";				
		String msg ="No Error";				
		String message="";			
		String SID=request.getParameter("sid")==null?"14353004":request.getParameter("sid");
		String Stu_institute="";
		String []course_id;//��ѡ�γ�ID
		int num_public=0;//��ѡ��ѡ����Ŀ
		String MAX_NUM_PUBLIC="2";//һѧ��һѧ������ѡ��ѡ����Ŀ
		int num_course;//��ѡ����Ŀ
		int time[][];//��������ʽ�洢��ѧ���Ͽ�ʱ���
		Boolean fliter=false;
		Boolean hide_time_crash=false;
		String connectString = "jdbc:mysql://localhost:3306/educational_admin_system"				
						+ "?autoReconnect=true&useUnicode=true"				
						+ "&characterEncoding=UTF-8"; 				
			StringBuilder table=new StringBuilder("");				
		try{				
			Class.forName("com.mysql.jdbc.Driver");				
			Connection con=DriverManager.getConnection(connectString, 				
						 "root", "yaojin");				
			Statement stat=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
			ResultSet rs;
			ResultSet rs_student_information=stat.executeQuery("select * from student Where Stu_id='"+SID+"'");
			if(rs_student_information.next())
			{
				Stu_institute=rs_student_information.getString("Stu_institute");
			}
			if(request.getParameter("xk")!=null&&request.getParameter("xk").equals("ѡ��"))
			{
				if(request.getParameter("hide").equals("true"))
				{
					%>
						<script type="text/javascript">	
							alert("ʱ���ͻ��ѡ��ʧ��")
						</script>
						<%
				}
				else if(request.getParameter("course_type").equals("Public Elective")
					&&request.getParameter("num_public").equals(MAX_NUM_PUBLIC)
					)
					{
						%>
						<script type="text/javascript">	
							alert("ѡ��ʧ�ܣ���ѡ���Ѵ��������:2��")
						</script>
						<%
						
					}
				else
				{
					int num=stat.executeUpdate("INSERT INTO select_course(Stu_id,Teacher_id,Course_id,course_year,course_session) VALUES('"+
					SID+"','"+request.getParameter("T_id")+"','"+request.getParameter("course_id")+"','"+request.getParameter("course_year")
					+"','"+request.getParameter("course_session")+"');");
					if(num>=1)
					{
						%><script type="text/javascript">	
							alert("ѡ�γɹ�")
						</script><%
					}
					else
					{
						%><script type="text/javascript">	
							alert("ѡ��ʧ��")
						</script><%
					}
				}
					
			}
			if(request.getParameter("xk")!=null&&request.getParameter("xk").equals("�˿�"))
			{
				int num=stat.executeUpdate("DELETE  FROM select_course WHERE  Stu_id='"
									+SID+"' and Course_id='"+request.getParameter("course_id")+"'");
				if(num>=1)
				{
					%><script type="text/javascript">	
							alert("�˿γɹ�")
						</script><%	
				}else					
				{
					%><script type="text/javascript">	
							alert("�˿�ʧ��")
						</script><%	
				}
			}
			
			//ͨ��SID��Table select_course��ȡѧ����ѡ����Ϣ
			ResultSet rs_student_course_count=stat.executeQuery("select count(*) as rowCount from select_course Where Stu_id='"+SID+"' and course_year='2017' and course_session ='1'");
            rs_student_course_count.next();
            num_course= rs_student_course_count.getInt("rowCount");//��¼��ѡ�γ�����
			time=new int[num_course][2];
			ResultSet rs_student_course=stat.executeQuery("select * from select_course Where Stu_id='"+SID+"' and course_year='2017' and course_session ='1'");
			int index=0;
			course_id=new String[num_course];
			while(rs_student_course.next()){
				course_id[index++]=rs_student_course.getString("Course_id");
			}
			for(int i=0;i<num_course;i++)
			{
				ResultSet course_info=stat.executeQuery("select * from course where course_id='"+course_id[i]+"'");
				if(course_info.next())
				{
					//���ı���ʱ��תΪ��������ʱ���ͻ�����ܶ���2��->202,���ĵ�11��->411,...
					String temp=course_info.getString("course_time");
					int begin=0,end=0;
					int num1_begin_index,num2_begin_index;
					switch(temp.charAt(1))
					{
						case 'o': end=begin=100;break;//Mon
						case 'u': end=begin=200;break;//Tues
						case 'e': end=begin=300;break;//Wed
						case 'h': end=begin=400;break;//Thur
						case 'r': end=begin=500;break;//Fri
					}
					num1_begin_index=temp.indexOf(' ');
					num2_begin_index=temp.indexOf('~');
					begin+=Integer.valueOf(temp.substring(num1_begin_index+1,num2_begin_index));
					end+=Integer.valueOf(temp.substring(num2_begin_index+1,temp.length()));
					time[i][0]=begin;
					time[i][1]=end;
					
					//��¼ѧ����ѡ��ѡ������
					if( course_info.getString("course_type").equals("Public Elective"))
						num_public++;
				}	
			}
			if(request.getParameter("sx")!=null||request.getParameter("ctcl_button")!=null||request.getParameter("xk")!=null)			
			{				
				fliter=true;
				if(!request.getParameter("skxq").equals(""))				
					filter_state+=("course_campus='"+request.getParameter("skxq")+"'");						
				if(!request.getParameter("kclb").equals(""))				
				{				
					if(!filter_state.equals("")) filter_state+=" and ";				
					if(request.getParameter("kclb").equals("Public Elective"))
						filter_state+=("course_type='"+request.getParameter("kclb")+"'");
					else if(request.getParameter("kclb").equals("Major Elective"))
						filter_state+="course_school='"+Stu_institute+"' and course_type='Major Elective'";
				}
				else
				{
					if(!filter_state.equals("")) filter_state+=" and ";				
					filter_state+="(course_type='Public Elective' or(course_school='"+Stu_institute+"' and course_type='Major Elective'))";
				}
				if(!request.getParameter("kcmc").equals(""))				
				{				
					if(!filter_state.equals("")) filter_state+=" and ";				
					filter_state+=("course_name='"+request.getParameter("kcmc")+"'");				
				}				
				if(!request.getParameter("sj").equals(""))				
				{				
					if(!filter_state.equals("")) filter_state+=" and ";				
					filter_state+=("course_time='"+request.getParameter("sj")+"'");				
				}				
				if(!request.getParameter("rkjsgh").equals(""))				
				{				
					if(!filter_state.equals("")) filter_state+=" and ";				
					filter_state+=("T_id='"+request.getParameter("rkjsgh")+"'");				
				}				
				if(!filter_state.equals(""))				
				filter_state=" WHERE "+filter_state;				
				select="select * from course "+filter_state;				
				rs=stat.executeQuery(select);				
			}
			else				
				rs=stat.executeQuery("select * from course Where course_year='2017' and course_session= '1' and (course_type='Public Elective' or (course_school='"+Stu_institute+"' and course_type='Major Elective'))");				
%> 				
<html xmlns="http://www.w3.org/1999/xhtml"> 
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=8" />
	<title>ѡ��</title>	
	<link rel="stylesheet" type="text/css" href="http://uems.sysu.edu.cn/elect/static/css/site.css" media="all"> 
	<link rel="stylesheet" type="text/css" href="http://uems.sysu.edu.cn/elect/static/css/jquery.loadmask.css" media="all"> 
	<style type="text/css">
		#xnd, #xq, #kcmc, #sksjdd, #zjjsxm{
			width: 75px;
		}
		
		.grid th, .grid th div{	
			font-size: 0.9em;
			line-height: 1.2em;
			padding: 0;
			margin: 0;
		}
		.grid td{
			font-size: 1.1em;
		}
		
		.grid th{
			height: 24px !important;	
			overflow: hidden;
		}
		
		td.s{
			font-size: 0.9em;
		}
	</style>
</head>

<body>
	<div id='scrumb'>
		<a href="types?sid=2b5f055e-dec4-41b8-a619-aa19066eeb24">���ؿγ�����</a>
		<input type="hidden" id="milliseconds" value=1510474654863 />
		ϵͳʱ��: <label id="sqlCurrentTime"></label>
		<input type="button" id='logout' value="�˳�ϵͳ" />
	</div>

	
	<div class='toolbar'>
	<form id='form' action='' method="post">
		
			<input type="hidden" id="sid" name="sid" value="<%=SID%>"/>
			<input type="hidden" name="ctcl" id="ctcl"  value="<%
						if(request.getParameter("ctcl_button")!=null&&request.getParameter("ctcl_button").equals("���س�ͻ")) {out.print("�����س�ͻ");hide_time_crash=true;} 
						else if(request.getParameter("ctcl_button")!=null&&request.getParameter("ctcl_button").equals("�����س�ͻ")) out.print("���س�ͻ");
						else if(request.getParameter("ctcl")!=null)  {out.print(request.getParameter("ctcl"));if(request.getParameter("ctcl").equals("�����س�ͻ")) hide_time_crash=true;}
						else out.print("���س�ͻ");%>"/>

			<table style='width:100%; margin-top:15px'>
				<tr>
					<td>�γ����</td>
					<td>�Ͽ�У��</td>
					<td>�γ�����</td>
					<td>ʱ��</td>
					<td>�ον�ʦ����</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>
						<select name="kclb" id="kclb">
							<option value=''>ȫ��</option>
								<option value="Public Elective" <%if(fliter==true&&request.getParameter("kclb").equals("Public Elective")) out.print("selected");%>>Public Elective</option>
								<option value="Major Elective"  <%if(fliter==true&&request.getParameter("kclb").equals("Major Elective")) out.print("selected");%>>Major Elective</option>
						</select>
					</td>
					<td>
						<select name="skxq" id="skxq">
							<option value=''>ȫ��</option>
								<option value="North" <%if(fliter==true&&request.getParameter("skxq").equals("North")) out.print("selected");%>>��У��</option>
								<option value="South" <%if(fliter==true&&request.getParameter("skxq").equals("South")) out.print("selected");%>>��У��</option>
								<option value="East"  <%if(fliter==true&&request.getParameter("skxq").equals("East")) out.print("selected");%>>��У��</option>
								<option value="Zhuh"  <%if(fliter==true&&request.getParameter("skxq").equals("Zhuh")) out.print("selected");%>>�麣У��</option>
								<option value="Shenz" <%if(fliter==true&&request.getParameter("skxq").equals("Shenz")) out.print("selected");%>>����У��</option>
						</select>
					</td>
					<td>
						<input type="text" name="kcmc" id="kcmc" value="<%if(fliter==true) out.print(request.getParameter("kcmc"));%>" />
					</td>
					<td>
						<input type="text" name="sj" id="sj" value="<%if(fliter==true) out.print(request.getParameter("sj"));%>" />
					</td>
					<td>
						<input type="text" name="rkjsgh" id="rkjsgh" value="<%if(fliter==true) out.print(request.getParameter("rkjsgh"));%>" />
					</td>
					<td style='text-align:right; width:90%; padding-right: 8px'>
						<input name="ctcl_button" id="ctcl_button" type="submit" value="<%
						if(request.getParameter("ctcl_button")!=null&&request.getParameter("ctcl_button").equals("���س�ͻ")) out.print("�����س�ͻ"); 
						else if(request.getParameter("ctcl_button")!=null&&request.getParameter("ctcl_button").equals("�����س�ͻ")) out.print("���س�ͻ");
						else if(request.getParameter("ctcl")!=null) out.print(request.getParameter("ctcl"));
						else out.print("���س�ͻ");%>" />
					</td>					
					<td style='text-align:right; width: 50%; padding-right: 8px'>
						<input name="sx" id="sx" type="submit" value="ɸѡ" />
					</td>
				</tr>
			</table>
		</form>
	</div>
	
	<div id='content'>
		<h3 style='margin-top:1em'>ѡ���б� 
			<label id="toolbarTuitionMessage"></label>
		</h3>
		<div class="grid-container">
			<table class='grid' style='width: 100%;' id='elected'>
				<thead>
					<tr>
						<th><div style='width: 50px'>�γ̺�</div></th>
						<th> <div style='width: 80px'>�γ�����</div></th>
						<th><div style='width: 60px'>����ѧ��</div></th>
						<th><div style='width: 60px'>����ѧ��</div></th>
						<th><div style='width: 50px'>ѧ��</div></th>
						<th><div style='width: 50px'>ѧʱ</div></th>
						<th><div style='width: 50px'>��������</div></th>
						<th><div style='width: 80px'>�γ����</div></th>
						<th><div style='width: 50px'>�Ͽ�У��</div></th>
						<th><div style='width: 50px'>����ѧԺ</div></th>
						<th><div style='width: 80px'>�Ͽ�ʱ��</div></th>
						<th><div style='width: 80px'>�Ͽεص�</div></th>
						<th><div style='width: 90px'>��ѧ���</div></th>
						<th><div style='width: 90px'>���ѡ������</div></th>
						<th><div style='width: 80px'>�ον�ʦ����</div></th>
						<th><div style='width: 50px'>ѡ��״̬</div></th>			
					</tr>
				</thead>
				<tbody>
							<%
							while(rs.next()){
								String temp=rs.getString("course_time");
								int begin=0,end=0;
								int num1_begin_index,num2_begin_index;	
								switch(temp.charAt(1))	
								{	
									case 'o': end=begin=100;break;//Mon	
									case 'u': end=begin=200;break;//Tues	
									case 'e': end=begin=300;break;//Wed	
									case 'h': end=begin=400;break;//Thur	
									case 'r': end=begin=500;break;//Fri	
								}	
								num1_begin_index=temp.indexOf(' ');	
								num2_begin_index=temp.indexOf('~');	
								begin+=Integer.valueOf(temp.substring(num1_begin_index+1,num2_begin_index));	
								end+=Integer.valueOf(temp.substring(num2_begin_index+1,temp.length()));	
								boolean hide=false;	
								for(int i=0;i<num_course;i++)	
								{	
									if((begin>=time[i][0]&&begin<=time[i][1])||(end>=time[i][0]&&end<=time[i][1]))	
									{	
										hide=true;break;	
									}	
								}
								Boolean sel=false;
								for(int i=0;i<num_course;i++)
								if(rs.getString("course_id").equals(course_id[i]))
								{sel=true;break;}								
								if(hide_time_crash&&hide&&!sel) continue;	
								
								
							%>
							<form  action='' method="post">
							<input type="hidden" id="sid" name="sid" value="<%=SID%>"/>
							<input type="hidden" name="ctcl" id="ctcl"  value="<%
								if(request.getParameter("ctcl_button")!=null&&request.getParameter("ctcl_button").equals("���س�ͻ")) {out.print("�����س�ͻ");hide_time_crash=true;} 
								else if(request.getParameter("ctcl_button")!=null&&request.getParameter("ctcl_button").equals("�����س�ͻ")) out.print("���س�ͻ");
								else if(request.getParameter("ctcl")!=null)  {out.print(request.getParameter("ctcl"));if(request.getParameter("ctcl").equals("�����س�ͻ")) hide_time_crash=true;}
								else out.print("���س�ͻ");%>"
								/>

							<input type="hidden" id="kclb" name="kclb" value="<%if(fliter) out.print(request.getParameter("kclb"));%>"/>
							<input type="hidden" id="skxq" name="skxq" value="<%if(fliter) out.print(request.getParameter("skxq"));%>"/>
							<input type="hidden" id="kcmc" name="kcmc" value="<%if(fliter) out.print(request.getParameter("kcmc"));%>"/>
							<input type="hidden" id="sj" name="sj" value="<%if(fliter) out.print(request.getParameter("sj"));%>"/>
							<input type="hidden" id="rkjsgh" name="rkjsgh" value="<%if(fliter) out.print(request.getParameter("rkjsgh"));%>"/>
							
							<input type="hidden" id="course_id" name="course_id" value="<%=rs.getString("course_id")%>";/>
							<input type="hidden" id="course_type" name="course_type" value="<%=rs.getString("course_type")%>";/>
							<input type="hidden" id="num_public" name="num_public" value="<%=num_public%>";/>
							<input type="hidden" id="T_id" name="T_id" value="<%=rs.getString("T_id")%>";/>
							<input type="hidden" id="course_year" name="course_year" value="<%=rs.getString("course_year")%>";/>
							<input type="hidden" id="course_session" name="course_session" value="<%=rs.getString("course_session")%>";/>
							<input type="hidden" id="hide" name="hide" value="<%=hide%>"/>
							
						    <tr class="odd" >
								<td class='c'><%=rs.getString("course_id")%></td>
								<td class='c'><%=rs.getString("course_name")%></td>
								<td class='c'><%=rs.getString("course_year")%></td>
								<td class='c'><%=rs.getString("course_session")%></td>
								<td class='c'><%=rs.getString("credit")%></td>
								<td class='c'><%=rs.getString("course_hour")%></td>
								<td class='c'><%=rs.getString("course_period")%></td>
								<td class='c'><%=rs.getString("course_type")%></td>	
								<td class='c'><%=rs.getString("course_campus")%></td>
								<td class='c'><%=rs.getString("course_school")%></td>
								<td class='c'><%=rs.getString("course_time")%></td>
								<td class='c'><%=rs.getString("course_room")%></td>
								<td class='c'><%=rs.getString("course_class_number")%></td>
								<td class='c'><%=rs.getString("course_max_stu")%></td>
								<td class='c'><%=rs.getString("T_id")%></td>
								<td class='c'><input name="xk" id="xk" type="submit" value="<%
									if(sel) out.print("�˿�");
									else out.print("ѡ��");
									%>" >
								</td>
						   </tr>
						   </form>
							<%
							}
							rs.close();
							stat.close();
							con.close();
						}
						catch (Exception e){
						  //msg=e.getMessage();
						  %>
						  <script type="text/javascript">	
							alert(<%=e.getMessage()%>)
						  </script>
						  <%
						}
					%>
				</tbody>
			</table>
		</div>
	</div>
	

</body>
</html>


