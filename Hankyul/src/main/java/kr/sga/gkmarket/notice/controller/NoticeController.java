package kr.sga.gkmarket.notice.controller;



import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.JsonObject;

import io.swagger.v3.oas.annotations.parameters.RequestBody;
import kr.sga.gkmarket.notice.service.NoticeFileService;
import kr.sga.gkmarket.notice.service.NoticeService;
import kr.sga.gkmarket.notice.vo.BackNoticeFileVO;
import kr.sga.gkmarket.notice.vo.BackNoticeVO;
import lombok.extern.slf4j.Slf4j;


@Controller 
@Slf4j
public class NoticeController {
	
    @Autowired
    private NoticeService noticeService; //서비스 연결
    @Autowired
    private NoticeFileService noticeFileService;

    private String os = System.getProperty("os.name").toLowerCase();
    
    @GetMapping(value = "/MainView/NoticeControl")
	public String NoticeControlPage() {
		return "/NoticeControl";
	}
    
    @GetMapping(value = "/notice/getList") //주소 지정
    @ResponseBody
    public List<BackNoticeVO> getNoticeList(){
    	log.info("NoticeController-openNoticeList 호출");
    	
    	List<BackNoticeVO> list = noticeService.getNotice();
    	
    	log.info("NoticeController-openNoticeList 리턴 : " +  list);
    	return list;
    }
    
    
    @SuppressWarnings("deprecation")
    @PostMapping(value = "/notice/insertNotice")
    @ResponseBody
	public void insertNotice(@RequestBody BackNoticeVO backNoticeVO, @RequestPart(value = "fileUp", required = false) MultipartFile mfile) {
		noticeService.insertNotice(backNoticeVO); // DB에 저장
		if(mfile != null ) {
			BackNoticeFileVO imageFile = new BackNoticeFileVO();
			int ref = noticeService.selectSeq();
			String realPath = "";
			try {
				if (os.contains("win")) {
					realPath = "D:/image/";
				} else {
					realPath = "/resources/Back/";
				}
				String saveName = UUID.randomUUID() + "_" + mfile.getOriginalFilename();
				
				if(realPath != null && realPath != "") {
					File target = new File(realPath, saveName);
					mfile.transferTo(target);
					imageFile.setBack_Notice_Ref(ref);
					imageFile.setBack_Noticefile_OriName(mfile.getOriginalFilename());
					imageFile.setBack_Noticefile_SaveName(saveName);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			noticeFileService.insertFile(imageFile);
			imageFile.toString();
		}
		
	}
   /* @PostMapping(value = "/notice/updateNotice")
    @ResponseBody
    public void updateNotice(@RequestBody BackNoticeVO backNoticeVO ,@RequestPart(value = "fileUp", required = false) MultipartFile mfile) {
    	BackNoticeVO dbVO = noticeService.selectIdx(backNoticeVO.getBack_Notice_Idx());
    	if(dbVO != null) {
    		noticeService.updateNotice(backNoticeVO);
    		
    		List<BackNoticeFileVO> refList = noticeFileService.selectRefList(backNoticeVO.getBack_Notice_Idx());

    		String realPath = "";
        	if (os.contains("win")) {
    			realPath = "D:/image/";
    		} else {
    			realPath = "/resources/Back/";
    		}
        	noticeFileService.deleteFile(backNoticeVO.getBack_Notice_Idx(), realPath);
        	}
    	
    	
        	if(mfile != null ) {
    			BackNoticeFileVO imageFile = new BackNoticeFileVO();
    			int ref = noticeService.selectSeq();
    			String realPath = "";
    			try {
    				if (os.contains("win")) {
    					realPath = "D:/image/";
    				} else {
    					realPath = "/resources/Back/";
    				}
    				String saveName = UUID.randomUUID() + "_" + mfile.getOriginalFilename();
    				
    				if(realPath != null && realPath != "") {
    					File target = new File(realPath, saveName);
    					mfile.transferTo(target);
    					imageFile.setBack_Notice_Ref(ref);
    					imageFile.setBack_Noticefile_OriName(mfile.getOriginalFilename());
    					imageFile.setBack_Noticefile_SaveName(saveName);
    				}
    			} catch (IOException e) {
    				e.printStackTrace();
    			}
    			noticeFileService.insertFile(imageFile);
    			imageFile.toString();
    			
    	}
    	
    }*/
    @PostMapping(value = "/notice/deleteNotice")
    @ResponseBody
    public void deleteNotice(@RequestParam("backNotice") int backNotice){
    	String realPath = "";
    	if (os.contains("win")) {
			realPath = "D:/image/";
		} else {
			realPath = "/resources/Back/";
		}
    	noticeFileService.deleteFile(backNotice, realPath);
    	
    	noticeService.deleteNotice(backNotice);
        
        
        
    }
  
//----------------------파일 업로드------------------------//
    
    @GetMapping(value = "/notice/fileList")
    @ResponseBody
    public List<BackNoticeFileVO> getNoticeFileList(){
    	List<BackNoticeFileVO> list = noticeFileService.getNoticeFileList();
    	
    	return list;
    }
   
    @SuppressWarnings("deprecation")
    @PostMapping(value = "/notice/insertFile")
    @ResponseBody
    public String insertFile(@RequestPart(value = "fileUp", required = false) MultipartFile mfile) {
    	BackNoticeFileVO imageFile = new BackNoticeFileVO();
    	int ref = noticeService.selectSeq();
    	String realPath = "";
    	if(mfile != null ) {
			try {
				if (os.contains("win")) {
					realPath = "D:/image/";
				} else {
					realPath = "/resources/Back/";
				}
				String saveName = UUID.randomUUID() + "_" + mfile.getOriginalFilename();
				
				if(realPath != null && realPath != "") {
					File target = new File(realPath, saveName);
					mfile.transferTo(target);
					imageFile.setBack_Notice_Ref(ref);
					imageFile.setBack_Noticefile_OriName(mfile.getOriginalFilename());
					imageFile.setBack_Noticefile_SaveName(saveName);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			noticeFileService.insertFile(imageFile);
		}	
			
    	return imageFile.toString();
    }
    
  /*  @PostMapping(value = "notice/deleteFile")
    @ResponseBody
    public void deleteFile(@RequestParam int noticeFileId) {
    	String realPath = "";
    	if (os.contains("win")) {
			realPath = "D:/image/";
		} else {
			realPath = "/resources/Back/";
		}
		
    	noticeFileService.deleteFile(noticeFileId, realPath);
    }
    */
    
}