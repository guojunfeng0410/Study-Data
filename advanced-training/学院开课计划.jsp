<%@ page contentType="text/html;charset=gb2312" 
language="java" import="java.util.*,java.sql.*"%>
<!-- ��Ҫ����keyΪkkxy,ֵΪѧ������ѧԺ�Ĳ�����-->
<!DOCTYPE html>
<% 
		request.setCharacterEncoding("utf-8");				
		String select="";				
		String filter_state="";				
		String msg ="No Error";				
		String message="";				
		Boolean fliter=false;
		String connectString = "jdbc:mysql://localhost:3306/educational_admin_system"				
						+ "?autoReconnect=true&useUnicode=true"				
						+ "&characterEncoding=UTF-8"; 				
			StringBuilder table=new StringBuilder("");				
		try{				
			Class.forName("com.mysql.jdbc.Driver");				
			Connection con=DriverManager.getConnection(connectString, 				
						 "root", "yaojin");				
			Statement stat=con.createStatement();				
			ResultSet rs;				
			if(request.getMethod().equals("POST"))				
			{				
				fliter=true;
				if(!request.getParameter("skxq").equals(""))				
					filter_state+=("course_campus='"+request.getParameter("skxq")+"'");				
				if(!request.getParameter("xnd").equals(""))				
				{				
					if(!filter_state.equals("")) filter_state+=" and ";				
					filter_state+=("course_year='"+request.getParameter("xnd")+"'");				
				}				
				if(!request.getParameter("xq").equals(""))				
				{				
					if(!filter_state.equals("")) filter_state+=" and ";				
					filter_state+=("course_session='"+request.getParameter("xq")+"'");				
				}				
				if(!request.getParameter("kclb").equals(""))				
				{				
					if(!filter_state.equals("")) filter_state+=" and ";				
					filter_state+=("course_type='"+request.getParameter("kclb")+"'");				
				}				
				if(!request.getParameter("kkxy").equals(""))				
				{				
					if(!filter_state.equals("")) filter_state+=" and ";				
					filter_state+=("course_school='"+request.getParameter("kkxy")+"'");				
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
				rs=stat.executeQuery("select * from course Where course_year='2017' and course_session= '1' and course_school='"+request.getParameter("kkxy")+"'");				
%> 				
<html xmlns="http://www.w3.org/1999/xhtml"> 
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=8" />
	<title>ѧԺ���μƻ�</title>	
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
			<input type="hidden" name="kkxy" id="kkxy" value="<%out.print(request.getParameter("kkxy"));%>" />
					

			<table style='width:100%; margin-top:15px'>
				<tr>
					<td style='padding-left: 9px'>ѧ���</td>
					<td>ѧ��</td>
					<td>�γ����</td>
					<td>�Ͽ�У��</td>
					<td>�γ�����</td>
					<td>ʱ��</td>
					<td>�ον�ʦ����</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style='padding-left: 9px'>
						<select name="xnd" id="xnd" style="width:90px">
							<option value=''>ȫ��</option>
								<option value="2004" <%if(fliter==true&&request.getParameter("xnd").equals("2004")) out.print("selected");%>>2004</option>
								<option value="2005" <%if(fliter==true&&request.getParameter("xnd").equals("2005")) out.print("selected");%>>2005</option>
								<option value="2006" <%if(fliter==true&&request.getParameter("xnd").equals("2006")) out.print("selected");%>>2006</option>
								<option value="2007" <%if(fliter==true&&request.getParameter("xnd").equals("2007")) out.print("selected");%>>2007</option>
								<option value="2008" <%if(fliter==true&&request.getParameter("xnd").equals("2008")) out.print("selected");%>>2008</option>
								<option value="2009" <%if(fliter==true&&request.getParameter("xnd").equals("2009")) out.print("selected");%>>2009</option>
								<option value="2010" <%if(fliter==true&&request.getParameter("xnd").equals("2010")) out.print("selected");%>>2010</option>
								<option value="2011" <%if(fliter==true&&request.getParameter("xnd").equals("2011")) out.print("selected");%>>2011</option>
								<option value="2012" <%if(fliter==true&&request.getParameter("xnd").equals("2012")) out.print("selected");%>>2012</option>
								<option value="2013" <%if(fliter==true&&request.getParameter("xnd").equals("2013")) out.print("selected");%>>2013</option>
								<option value="2014" <%if(fliter==true&&request.getParameter("xnd").equals("2014")) out.print("selected");%>>2014</option>
								<option value="2015" <%if(fliter==true&&request.getParameter("xnd").equals("2015")) out.print("selected");%>>2015</option>
								<option value="2016" <%if(fliter==true&&request.getParameter("xnd").equals("2016")) out.print("selected");%>>2016</option>
								<option value="2017" <%if(fliter==false) out.print("selected"); else if(request.getParameter("xnd").equals("2017")) out.print("selected");%> >2017</option>
								<option value="2018" <%if(fliter==true&&request.getParameter("xnd").equals("2018")) out.print("selected");%>>2018</option>
								<option value="2019" <%if(fliter==true&&request.getParameter("xnd").equals("2019")) out.print("selected");%>>2019</option>
						</select>
					</td>
					<td>
						<select name="xq" id="xq">
							<option value=''>ȫ��</option>
								<option value="1" <%if(fliter==false) out.print("selected"); else if(request.getParameter("xq").equals("1")) out.print("selected");%>>��һѧ��</option>
								<option value="2" <%if(fliter==true&&request.getParameter("xq").equals("2")) out.print("selected");%>>�ڶ�ѧ��</option>
						</select>
					</td>
					<td>
						<select name="kclb" id="kclb">
							<option value=''>ȫ��</option>
								<option value="Public Required" <%if(fliter==true&&request.getParameter("kclb").equals("Public Required")) out.print("selected");%>>Public Required</option>
								<option value="Public Elective" <%if(fliter==true&&request.getParameter("kclb").equals("Public Elective")) out.print("selected");%>>Public Elective</option>
								<option value="Major Required"  <%if(fliter==true&&request.getParameter("kclb").equals("Major Required")) out.print("selected");%>>Major Required</option>
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
					<td style='text-align:right; width: 50%; padding-right: 8px'>
						<input type="submit" value="ɸѡ" />
					</td>
				</tr>
			</table>
		</form>
	</div>
	
	<div id='content'>
		<h3 style='margin-top:1em'>ѧԺ���μƻ��� 
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
						<th><div style='width: 80px'>�Ͽ�ʱ��</div></th>
						<th><div style='width: 80px'>�Ͽεص�</div></th>
						<th><div style='width: 90px'>��ѧ���</div></th>
						<th><div style='width: 90px'>���ѡ������</div></th>
						<th><div style='width: 80px'>�ον�ʦ����</div></th>						
					</tr>
				</thead>
				<tbody>
							<%
							while(rs.next()){
							%>
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
								<td class='c'><%=rs.getString("course_time")%></td>
								<td class='c'><%=rs.getString("course_room")%></td>
								<td class='c'><%=rs.getString("course_class_number")%></td>
								<td class='c'><%=rs.getString("course_max_stu")%></td>
								<td class='c'><%=rs.getString("T_id")%></td>
						   </tr>
							<%
							}
							rs.close();
							stat.close();
							con.close();
						}
						catch (Exception e){
						  msg=e.getMessage();
						}
					%>
				</tbody>
			</table>
		</div>
	</div>

</body>
</html>


