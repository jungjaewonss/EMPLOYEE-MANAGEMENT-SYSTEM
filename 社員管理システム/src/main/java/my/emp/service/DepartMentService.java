package my.emp.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import my.emp.entity.DepartMent;
import my.emp.entity.SearchOption;
import my.emp.mapper.DepartMentMapper;

@Service
public class DepartMentService {
	
	@Autowired
	private DepartMentMapper departmentmapper;
	
	public int join(DepartMent member) {
		int result = departmentmapper.join(member);
		
		return result;
	}
	
	public List<DepartMent> allList(){
		return departmentmapper.allList();
	}
	
	public List<DepartMent> optionList(SearchOption option){
		return departmentmapper.optionList(option);
	}
	
	public DepartMent oneInfo(DepartMent department) {
		return departmentmapper.oneInfo(department);
	}
	
	public int delete(DepartMent department) {
		return departmentmapper.delete(department);
	}
	
	public int update(DepartMent department) {
		return departmentmapper.update(department);
	}
	
	public String searchDept(String deptno) {
		return departmentmapper.searchDept(deptno);
	}
	
	public String uploadFile(HttpServletRequest request, RedirectAttributes rttr) {
		MultipartRequest multi = null;
		FileReader fr = null;
		BufferedReader br = null;
			
		int fileMaxSize = 10*1024*1024; 
		String savePath = request.getRealPath("resources/upload"); 
		
		File file= new File(savePath);		
		if(!file.exists()) {
			file.mkdir();
		}
				
		try {
			multi = new MultipartRequest(request,savePath,fileMaxSize,"UTF-8",new DefaultFileRenamePolicy());
			int val = Integer.parseInt(multi.getParameter("val"));
			Enumeration files = multi.getFileNames();
			
			while(files.hasMoreElements()) {
				String fileName = (String)files.nextElement();
				String saveFile = multi.getFilesystemName(fileName);
				
				
				File uploadfile = new File(savePath,saveFile);
				
				fr = new FileReader(uploadfile);
				br = new BufferedReader(fr);
				
				String str = "";
				List<DepartMent> departs = new ArrayList<DepartMent>();
				DepartMent dp = new DepartMent();
				int i = 0;
				while((str = br.readLine()) != null) {
					
					String [] strs = str.split(",");
						
						if(i > 0) {
							dp.setId(Integer.parseInt(strs[0]));
							dp.setName(strs[1]);
							dp.setDepartment(strs[2]); 
							dp.setPositions(strs[3]); 
							dp.setGender(strs[4]); 
							dp.setJoindate(strs[5]); 
							dp.setPhone(strs[6]);
							
							System.out.println(dp);
							departs.add(dp);
						}	
						i++;	
					}
								
				String msg = "";
				for(int j = 0 ; j < departs.size(); j++) {
					int check = departmentmapper.checkId(departs.get(j));
					
					if(check > 0) {
						if(val == 0) {
							msg = "同じユーザIDを持つデータが存在しているので、「登録不可能」";
							rttr.addAttribute("msg", msg);
							return "redirect:/department/allList";
						}
						else if(val == 1) {
							msg = "既存データ修正完了";
							rttr.addAttribute("msg", msg);
							return "redirect:/department/allList";
						}
						else {
							msg = "既存データ削除完了";
							rttr.addAttribute("msg", msg);
							return "redirect:/department/allList";
						}
					
					}
					
				}
				if(val == 0) {
					msg = "登録完了";
				}
				else if(val == 1) {
					msg = "存在しないユーザIDので、「修正不可」";
				}
				else {
					msg = "存在しないユーザIDので、「削除不可」";
				}
				rttr.addAttribute("msg", msg);					
			}
				
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				fr.close();
				br.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}		
		return "redirect:/department/allList";
	}
}
