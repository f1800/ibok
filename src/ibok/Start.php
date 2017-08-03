<?php

/**
*  入口
*/

namespace tianrang\ibok;

use tianrang\ibok\WebSocketServer;

class Start
{
	static private $instance = null;
	private $src_root;
	private $config;
	private $server;

	private function __construct()
	{
		
	}

	public function init(array $config=null)
	{
		if (null === self::$instance) {
			self::$instance = new Start();
		}

		self::$instance->src_root = dirname(dirname(__FILE__)) . DIRECTORY_SEPARATOR;

		$configs = require self::$instance->src_root . 'config.php';

		foreach ($config as $k => $v) {
			array_key_exists($k, $configs['base_set']) && $configs['base_set'][$k] = $v;
		}
		self::$instance->config = $configs;
		WebSocketServer::$config = $configs;
		return self::$instance;
	}

	/**
	 * 运行客户端
	 */
	public function clientRun()
	{
		$config = self::$instance->config['base_set'];
		$data = [
			'ip' => $config['host'] . ':' . $config['port'],
			'user_id' => 2,
		];

		ob_start();
		require self::$instance->src_root . 'tpl' . DIRECTORY_SEPARATOR . 'index.tpl';
		$contents = ob_get_clean();
		echo $contents;
	}

	/**
	 * 运行服务器
	 */
	public function serverRun()
	{
		$config = self::$instance->config;
		self::$instance->server = new WebSocketServer($config['base_set']['host'], $config['base_set']['port']);
		## 配置服务器
		self::$instance->server->set($config['server_set']);

		self::$instance->server->on('open', function ($ws, $request)use($config) {
			$ws->firstEnter($request);
		});

		//监听WebSocket消息事件
		self::$instance->server->on('message', function ($ws, $frame) {
			$ws->sendAll($frame, $tip=null);
		});
		  
		//监听WebSocket连接关闭事件 
		// self::$instance->server->on('close', function ($ws, $fd) {
		//     echo "client-{$fd} is closed\n";
		// });
		
		printf($config['base_set']['server_tip']);
		self::$instance->server->start();
	}

	private function __clone()
	{
		
	}
}