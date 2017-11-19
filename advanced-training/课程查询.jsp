<%@ page contentType="text/html;charset=gb2312" 
language="java" import="java.util.*,java.sql.*"%>
<!--需要传入学生的学号(key为sid)-->
<!DOCTYPE html>
<% 
	request.setCharacterEncoding("gb2312");	
	String connectString = "jdbc:mysql://localhost:3306/educational_admin_system"				
						+ "?autoReconnect=true&useUnicode=true"				
						+ "&characterEncoding=UTF-8"; 				
	int time[][];//以数字形式存储该学生上课时间段
	int num_course;//已选课数目
	String []course_id;//已选课程ID
	String []course_name;//已选课程名称
	String SID=request.getParameter("sid")==null?"14353004":request.getParameter("sid");	
	try{				
		Class.forName("com.mysql.jdbc.Driver");				
		Connection con=DriverManager.getConnection(connectString, 				
						 "root", "yaojin");				
		Statement stat=con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		//通过SID从Table select_course获取学生的选课信息
		ResultSet rs_student_course_count=stat.executeQuery("select count(*) as rowCount from select_course Where Stu_id='"+SID+	"' and course_year='2017' and course_session ='1'");
        rs_student_course_count.next();    
        num_course= rs_student_course_count.getInt("rowCount");//记录已选课程数量    
		time=new int[num_course][2];
		ResultSet rs_student_course=stat.executeQuery("select * from select_course Where Stu_id='"+SID+"' and course_year='2017'	 and course_session ='1'");
		int index=0;	
		course_id=new String[num_course];	
		course_name=new String[num_course];	
		while(rs_student_course.next()){	
			course_id[index++]=rs_student_course.getString("Course_id");	
		}	
		for(int i=0;i<num_course;i++)	
		{	
			ResultSet course_info=stat.executeQuery("select * from course where course_id='"+course_id[i]+"'");	
			if(course_info.next())	
			{	
				//将文本的时间转为数字用于时间冲突处理。周二第2节->202,周四第11节->411,...	
				String temp=course_info.getString("course_time");
				course_name[i]=course_info.getString("course_name");
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
			}
		}
	}
	catch (Exception e){								
		  %>				
		  <script type="text/javascript">				
			alert(<%=e.getMessage()%>)				
		  </script>				
		  <%	
		}	
%>		
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
	<title>课程查询</title>
	<script src="https://code.jquery.com/jquery-3.2.1.js" integrity="sha256-DZAnKJ/6XZ9si04Hgrsxu/8s717jcIzLy3oi35EouyE=" crossorigin="anonymous"></script>
	<!-- 引入element样式 -->
	<link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
	<!-- 引入element组件库 -->
	<script src="https://unpkg.com/element-ui/lib/index.js"></script>

	<!-- 最新版本的 Bootstrap 核心 CSS 文件 -->
	<link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
	<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
	<script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
	<style>
		header{

		}
		.title{
			height:30px;
			line-height: 20px;
			display: flex;
			justify-content: space-between;
			align-items: center;
			background: #d9edf7;
		}
		.title span{
			margin-left: 10px;
		}
		.title i{
			margin-right: 10px;
		}
		.form{
			margin: 20px 10px 0px;
		}
		.form-control{
			height: 25px;
			width: 170px;
			padding: 2px 12px;
		}
		.btn-box{
			margin: 10px auto;
		}
		.content,header{
			border: solid 1px #dedede;
			margin: 10px;
			margin-left: 10px;
			margin-right: 10px;
		}
		.course-table{
			margin: 10px 15px 0px 15px;
		}
		.course-table td,th{
		    vertical-align: middle !important; 
		    text-align: center;
		}
	</style>
</head>
<body>
	<header>
		<div class="title">
			<span>查询条件</span>
			<i class="el-icon-caret-bottom" id="caret1"></i>
		</div>
		<form action="" method="" class="form">
			<table class="table table-bordered" style="margin-bottom: 10px;">
				<tr>
					<td>学年度：</td>
					<td>
						<select class="form-control">
						  <option>2017-2018</option>
						  <option>2016-2017</option>
						  <option>2015-2016</option>
						  <option>2014-2015</option>
						  <option>2013-2014</option>
						  <option>2012-2013</option>
						  <option>2011-2012</option>
						</select>
					</td>
					<td>学期：</td>
					<td>
						<select class="form-control">
						  <option>第一学期</option>
						  <option>第二学期</option>
						  <option>第三学期</option>
						  <option>其他</option>
						</select>
					</td>
				</tr>
			</table>
			<div class="btn-box" style="display: flex;align-items: center; justify-content: center;">
				<button class="btn btn-default " type="submit">查询</button>
				<button class="btn btn-default " type="submit" style="margin: auto 15px;">打印</button>
				<button class="btn btn-default " type="submit">导出</button>
			</div>
		</form>
	</header>
	<div class="content">
		<div class="title">
			<span>课程表</span>
			<i class="el-icon-caret-bottom" id="caret2"></i>
		</div>
		<div class="course-table">
			<table class="table table-bordered">
				<tr class="info" style="height: 65px;">
					<th></th>
					<th>星期一</th>
					<th>星期二</th>
					<th>星期三</th>
					<th>星期四</th>
					<th>星期五</th>
					<th>星期六</th>
					<th>星期日</th>
				</tr>
				<tr>
					<th class="info">第1节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第2节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第3节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第4节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第5节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第6节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第7节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第8节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第9节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第10节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第11节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第12节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第13节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第14节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
				<tr>
					<th class="info">第15节</th>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</table>
		</div>
	</div>
	<script>
		// 控制显示与隐藏,图标的切换
		var flag1 = flag2 = 0;
		$("#caret1").click(function(){
			if(flag1%2 == 0)
			{
				$(".form").hide();
				$("#caret1").removeClass('el-icon-caret-bottom');
				$("#caret1").addClass('el-icon-caret-top');
			}
			else{
				$(".form").show();
				$("#caret1").removeClass('el-icon-caret-top');
				$("#caret1").addClass('el-icon-caret-bottom');
			}
			flag1++;
		});
		$("#caret2").click(function(){
			if(flag2%2 == 0){
				$(".course-table").hide();
				$("#caret2").removeClass('el-icon-caret-bottom');
				$("#caret2").addClass('el-icon-caret-top');
			}
			else{
				$(".course-table").show();
				$("#caret2").removeClass('el-icon-caret-top');
				$("#caret2").addClass('el-icon-caret-bottom');
			}
			flag2++;
		});
	</script>
</body>
</html>

