package my.emp.controller;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.javassist.tools.framedump;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import my.emp.entity.DepartMent;
import my.emp.entity.SearchOption;
import my.emp.mapper.DepartMentMapper;
import my.emp.service.DepartMentService;

@Controller
@RequestMapping("/department")
public class DepartMentController {
	
	@Autowired
	private DepartMentService service;
	
	@GetMapping("/joinForm")
	public String joinForm() {
		// 사원 등록 화면으로 이동
		return "register";
	}
	
	@ResponseBody
	@PostMapping(value="/join", produces="application/text;charset-utf-8")
	public void join(DepartMent department) {		
		// 사원 등록 기능
		service.join(department);
	}
	
	@GetMapping("/allList")
	public String allList(Model model , String msg) {
		List<DepartMent> list = service.allList();
		model.addAttribute("allList", list);
		model.addAttribute("msg", msg);
		
		return "departmentList";
	}
	
	@ResponseBody
	@PostMapping("/searchList")
	public List<DepartMent> searchList(SearchOption search) {
		List<DepartMent> optionList = service.optionList(search);
		
		return optionList;
	}
	
	@GetMapping("/updateForm")
	public String updateForm(DepartMent department, Model model) {
		DepartMent dp = service.oneInfo(department);
		
		model.addAttribute("one", dp);
		
		return "update";
	}
	
	@PostMapping("/update")
	public String update(DepartMent department) {
		System.out.println(department);
		service.update(department);
		
		return "redirect:/department/allList";
	}
	
	@ResponseBody
	@GetMapping("/delete")
	public int delete(DepartMent department) {
		return service.delete(department);
	}
	
	@GetMapping("/uploadCsv")
	public String uploadCsv(String val, Model model) {
		model.addAttribute("val", val);
		
		return "uploadCsv";
	}
	
	@PostMapping("/uploadFile")
	public String uploadFile(HttpServletRequest request, RedirectAttributes rttr) {
	//csvFile をアップロードしたり、csvFileのデータを読んでデータベースに同じIDを持つデータがあるかチェックしてメッセージ出力。
		String result = service.uploadFile(request, rttr);
		
		return result;
	}
}
