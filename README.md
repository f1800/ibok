# ibok
php+swoole，简单的聊天室，直播

例子：
<?php

## composer 自动加载
require './vendor/autoload.php';

## 项目初始化配置
$config = [
	'host' => '192.168.10.20'
	];

## 初始化项目实例
$bootstrap = tianrang\ibok\Start::init($config);

## 判断脚本运行模式
$type = $_GET['type'] ?? 'server';

## cli模式运行服务端脚本
if ($type === 'server') {
	preg_match("/cli/i", php_sapi_name()) === 0 && die('必须用CLI模式运行！');
	$bootstrap->serverRun();
}

## fcgi模式运行客户端脚本
if ($type === 'client') {
	$bootstrap->clientRun();
}