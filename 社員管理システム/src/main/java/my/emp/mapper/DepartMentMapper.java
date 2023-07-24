package my.emp.mapper;

import java.util.List;

import my.emp.entity.DepartMent;
import my.emp.entity.SearchOption;

public interface DepartMentMapper {
	int join(DepartMent department);
	List<DepartMent> allList();
	List<DepartMent> optionList(SearchOption option);
	DepartMent oneInfo(DepartMent department);
	int update(DepartMent department);
	int delete(DepartMent department);
	String searchDept(String deptno);
	int checkId(DepartMent departMent);
}
