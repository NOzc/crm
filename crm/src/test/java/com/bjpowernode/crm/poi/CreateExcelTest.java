package com.bjpowernode.crm.poi;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.HorizontalAlignment;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

/**
 * 使用apache-poi生成Excel文件
 */
public class CreateExcelTest {
    public static void main(String[] args) throws IOException {
        //创建HSSFWorkbook对象，对应一个Excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        //使用wb创建HSSFSheet对象，对应wb文件中的一页
        HSSFSheet sheet = wb.createSheet("学生列表");
        //使用sheet对象创建HSSFRow对象，对应sheet中的一行
        HSSFRow row = sheet.createRow(0);//参数：行的下标：行号，从0开始
        //使用row对象创建HSSFCell对象，对应row中的列
        HSSFCell cell = row.createCell(0);//参数：列号，从0开始
        cell.setCellValue("学号");
        cell = row.createCell(1);
        cell.setCellValue("姓名");
        cell = row.createCell(2);
        cell.setCellValue("年龄");

        //生成HSSFCellStyle对象，设置对齐方式
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HorizontalAlignment.CENTER);
        //保存十个学生的信息，使用sheet创建10个HSSFRow，对应sheet中的10行
        for (int i=1;i<=10;i++){
            row = sheet.createRow(i);
            cell = row.createCell(0);//参数：列号，从0开始
            cell.setCellValue(100+i);
            cell = row.createCell(1);
            cell.setCellValue("NAME"+i);
            cell = row.createCell(2);
            cell.setCellStyle(style);//给最后一列设置样式居中对齐
            cell.setCellValue(20+i);
        }
        //调用工具函数生成Excel文件
        //目录必须事先创建好，文件由poi创建
        OutputStream os = new FileOutputStream("C:\\Users\\Administrator\\Desktop\\workspace\\serverDir\\studentList.xls");
        wb.write(os);
        //关闭资源
        os.close();
        wb.close();
        System.out.println("======OK======");
    }
}
