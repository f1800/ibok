<html>
	<head>
	    <title>个人测试</title>
	    <style>
	    	#wrap{
	    	    margin:0 auto;
	    	    border: none;
	    	}
	    	#header{
	    	    margin:20px;
	    	    height:10%;
	    	}
	    	#contents{
	    	    position:relative;
	    	    margin:20px;
	    	    height:60%;
	    	    border: none;
	    	}
	    	#left_side{
	    	    position:absolute;
	    	    top:0px;
	    	    left:0px;
	    	    width:20%;
	    	    height:100%;
	    	}
	    	#content{
	    		position:absolute;
	    	    margin:0 32% 0 22%;
	    	    height:100%;
	    	    width: 46%;
	    	}
	    	#right_side{
	    	    position:absolute;
	    	    top:0px;
	    	    right:0px;
	    	    width:30%;
	    	    height:100%;
	    	}
	    	#footer{
	    	    margin:20px;
	    	    height:20%;
	    	}
	    </style>
	    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
	</head>
	<body>
	    <form id="form1">
	    <div id="wrap">
	    	<!-- 标题面板 -->
			<div class="panel panel-primary" id="header">
				<div class="panel-heading">
					<h3 class="panel-title">swoole + websocket 测试</h3>
				</div>
				<div class="panel-body">
					聊天服务器:
					<span id="server_status" style="color:red">未连接</span>
				</div>
			</div>
			
	        <div id="contents">
	        	<!-- 公共信息面板 -->
				<div class="panel panel-success" id="left_side">
					<div class="panel-heading">
						<h3 class="panel-title">公共信息面板</h3>
					</div>
					<div class="panel-body">
						登录信息
					</div>
				</div>
				
				<!-- 视频面板 -->
				<div class="panel panel-info" id="content">
					<div id="danmu">
					<div class="panel-heading">
						<h3 class="panel-title">视频面板</h3>
					</div>
					<div class="panel-body">
						开发中……
					</div>
					</div>
				</div>

				<!-- 聊天面板 -->
	            <div class="panel panel-warning" id="right_side">
	                <div class="panel-heading">
	                    <h3 class="panel-title">聊天面板</h3>
	                </div>
	                <div class="panel-body">
	                    <p id="chatbox"></p>
	                </div>
	            </div>
	        </div>

	        <!-- 个人中心面板 -->
	        <div class="panel panel-danger">
	        	<div class="panel-heading">
	        		<h3 class="panel-title">个人中心面板</h3>
	        	</div>
	        	<div class="panel-body">
	        		<br>&nbsp;&nbsp;&nbsp;&nbsp;
	        		发送消息：<input id="text" cols="20" rows="4" type="text" />
	        		<br><br>&nbsp;&nbsp;&nbsp;&nbsp;
	        		<input type="button" id="send" value="发送">
	        	</div>
	        </div>
	    </div>
	    </form>
	</body>
	<script src="https://cdn.bootcss.com/jquery/3.2.1/jquery.min.js"></script>
	<script src="https://static.ishappy.cn/js/jquery.danmu.min.js"></script>
	<!-- <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> -->
	<!-- <script src="https://cdn.bootcss.com/artDialog/7.0.0/dialog.js"></script> -->
	<!-- <script src="https://cdn.bootcss.com/blueimp-JavaScript-Templates/3.9.0/js/tmpl.min.js"></script> -->
	<script>
	$(function(){

		var wsServer = 'ws://' + "<?=$data['ip']?>";
		var websocket = new WebSocket(wsServer);

		websocket.onopen = function (evt) {
		    $('#server_status').text('已连接');
		}; 
		websocket.onclose = function (evt) { 
		    $('#server_status').text('断开连接');
		}; 
		  
		//弹幕开启
		$('#danmu').danmu('danmuStart');
		//弹幕颜色
		var d_color = new Array("#ccc","#000","red","pink","#ff0");
		websocket.onmessage = function (evt) {
			$('#danmu').danmu("addDanmu",{
							text: evt.data,
							color: d_color[Math.floor(Math.random() * (d_color.length - 1))],
							size: 1,
							position: 0,
							time: 7
						});
			$("#chatbox").append('<br /><br />' + evt.data);
			console.log(evt.data);
			// alert(evt.data);
		}; 
		  
		websocket.onerror = function (evt, e) { 
		    console.log('Error occured: ' + evt.data); 
		};

		$("#send").click(function(event) {
			websocket.send($('#text').val())
		});
	})
	</script>
</html>