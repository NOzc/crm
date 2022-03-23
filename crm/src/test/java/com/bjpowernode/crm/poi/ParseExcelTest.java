package com.bjpowernode.crm.poi;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

//解析Excel文件，将文件中的数据取出来
public class ParseExcelTest {
    public static void main(String[] args) throws IOException {
        //根据Excel文件生成HSSFWorkbook对象，封装了Excel文件的所有信息
        InputStream is = new FileInputStream("C:\\Users\\Administrator\\Desktop\\workspace\\serverDir\\activityList.xls");
        HSSFWorkbook wb = new HSSFWorkbook(is);
        //通过wb对象获取HSSFSheet对象，封装了一页的所有信息
        HSSFSheet sheet = wb.getSheetAt(0);//页的下标，从0开始
        //通过sheet获取HSSFRow对象，封装了一行的所有信息
        HSSFRow row = null;
        HSSFCell cell = null;
        for (int i=0;i<=sheet.getLastRowNum();i++){//getLastRowNum最后一行的下标
            row=sheet.getRow(i);//行的下标，从0开始
            for (int j=0;j<row.getLastCellNum();j++){//getLastCellNum最后一列的下标+1，总列数
                //根据row获取HSSFCell对象，封装了一列的所有信息
                cell=row.getCell(j);//列的下标，从0开始
                //获取列中的数据
                /*String value ="";
                if(cell!=null){
                    value= getCellValueForStr(cell);
                }*/
                System.out.print(getCellValueForStr(cell)+" ");
            }
            System.out.println("");
        }
    }

    /**
     * 从指定的HSSFCell对象中获取列的值
     */
    public static String getCellValueForStr(HSSFCell cell){
        String res = "";
        if (cell!=null){
            if (cell.getCellType()==HSSFCell.CELL_TYPE_STRING){
                res=cell.getStringCellValue();
            }else if (cell.getCellType()==HSSFCell.CELL_TYPE_NUMERIC){
                res=cell.getNumericCellValue()+"";
            }else if (cell.getCellType()==HSSFCell.CELL_TYPE_BOOLEAN){
                res=cell.getBooleanCellValue()+"";
            }else if (cell.getCellType()==HSSFCell.CELL_TYPE_FORMULA){
                res=cell.getCellFormula();
            }else {
                res="";
            }
        }
        return res;
    }
}
