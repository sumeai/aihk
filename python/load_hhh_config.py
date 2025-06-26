import configparser

def read_hhh_config():
    # 创建配置解析器
    config = configparser.ConfigParser()
    
    try:
        # 读取配置文件
        config.read('python/hhh.ini', encoding='utf-16')
        
        # 读取settings节中的active值
        active_profile = config.get('settings', 'active', fallback='prod')
        print(f"当前激活的环境: {active_profile}")
        
        # 根据active值读取对应环境的配置
        hhh_server = config.get(active_profile, 'hhh_server', fallback='')
        ai_common_server = config.get(active_profile, 'ai_common_server', fallback='')
        web_server = config.get(active_profile, 'web_server', fallback='')
        allow_origins = config.get(active_profile, 'allow_origins', fallback='')
        
        print("\n环境配置:")
        print(f"hhh_server: {hhh_server}")
        print(f"ai_common_server: {ai_common_server}")
        print(f"web_server: {web_server}")
        print(f"allow_origins: {allow_origins}")
        
        # 返回配置字典
        return {
            'active_profile': active_profile,
            'hhh_server': hhh_server,
            'ai_common_server': ai_common_server,
            'web_server': web_server,
            'allow_origins': allow_origins
        }
        
    except Exception as e:
        print(f"读取配置文件出错: {e}")
        return {}
