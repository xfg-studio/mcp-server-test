package cn.bugstack.mcp.server.test.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class TestService {

    @Tool(description = "打个招呼")
    public String test() {
        return "mcp test hi xfg!";
    }

}
