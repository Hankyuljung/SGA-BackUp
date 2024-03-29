package kr.sga.gkmarket.qna.service;


import java.util.List;

import kr.sga.gkmarket.qna.vo.BackQnaFileVO;
import kr.sga.gkmarket.qna.vo.BackQnaVO;
import kr.sga.gkmarket.qna.vo.QnaPagingVO;
import kr.sga.gkmarket.qna.vo.QnaUserNameVO;
import kr.sga.gkmarket.vo.CommVO;
import kr.sga.gkmarket.vo.PagingVO;



public interface BackQnaService {
	// qna 내용보기
	BackQnaVO selectByIdx(int idx);
	// qna 목록보기
	QnaPagingVO<BackQnaVO> selectList(CommVO commVO);
	// qna 저장
	void insert(BackQnaVO backQnaVO);
	// qna 수정    
	void update(BackQnaVO backQnaVO, String[] delFiles, String realPath);
	// qna 삭제     
	void delete(BackQnaVO backQnaVO);
	// 한글에 저장된 파일 가져오기
	BackQnaFileVO selectFiles(int idx);
	// 사용자 이름 가져오기
	List<QnaUserNameVO> selectUserName();
	
}
