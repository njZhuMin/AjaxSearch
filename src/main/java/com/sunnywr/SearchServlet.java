package com.sunnywr;

import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class SearchServlet extends HttpServlet {

    static List<String> datas = new ArrayList<String>();
    static {
        datas.add("ajax");
        datas.add("ajax post");
        datas.add("becky");
        datas.add("bill");
        datas.add("james");
        datas.add("jerry");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");
        resp.setCharacterEncoding("utf-8");
        // get keyword
        String keyword = req.getParameter("keyword");
        List<String> listData = getData(keyword);
        // result list to JSON
        Gson gson = new Gson();
        String json = gson.toJson(listData);
        resp.getWriter().write(json);
    }

    private List<String> getData(String keyword) {
        List<String> list = new ArrayList<String>();
        for(String data : datas)
            if(data.contains(keyword))
                list.add(data);
        return list;
    }
}
