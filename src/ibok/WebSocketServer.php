<?php

/**
*  websocket server
*/

namespace tianrang\ibok;

class WebSocketServer extends \Swoole\Websocket\Server
{
	static public $config;

	/**
	 * 绑定游客的$fd
	 */
	public function bindVisitor($fd)
	{
		## 判断是否为之前游客
		if ( ! isset($_COOKIE['name'])) {
			$no = rand(10000, 99999);
			$name = '游客'.$no;
			$_SESSION['u_name'] = $name;
		}
		$_SESSION['fd'] = $fd;
	}

	/**
	 * 第一次连接事件(消息推送)
	 */
	public function firstEnter($request)
	{
		$this->bindVisitor($request->fd);

		$tip = $_SESSION['u_name']."，".self::$config['base_set']['client_tip'].' ('.date('Y-m-d H:i:s', $request->server['request_time_float']).'，'.$request->server['remote_addr'].')';
		$this->push($request->fd, $tip); 
	}

	/**
	 *  全体消息(在线广播)
	 */
	public function sendAll($frame, $tip=null)
	{
		$fdinfo = $this->connection_info($frame->fd);
		if (null === $tip) {
			$tip = $_SESSION['u_name'].'  ('.date('Y-m-d', $fdinfo['last_time']).'  '.$fdinfo['remote_ip'].')：'.$frame->data;
		}

		$fds = $this->connection_list();
		array_walk($fds, function($fd)use($tip){
			$this->push($fd, $tip);
		});
	}
}


