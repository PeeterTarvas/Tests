package andmekaeve;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

public class Loader {
    private String filepath;
    private HashMap<String, List<String>> map;



    public Loader(String filepath) {
        this.filepath = filepath;
        this.map = new LinkedHashMap<>();
    }

    public void formatFileToHashMap() throws IOException {
        FileInputStream file = new FileInputStream(filepath);
        Workbook workbook = new XSSFWorkbook(file);
        Sheet sheet = workbook.getSheetAt(0);
        String prev = null;
        String current;
        Integer iteration_count = 0;
        int j = 0;
        for (Row row : sheet) {
            if (j != 0) {
                int i = 0;
                current = "%s_%s".formatted(String.valueOf(iteration_count), String.valueOf(row.getCell(0)));
                if (prev != null && !prev.equals(current)) {
                    if (map.containsKey(current)) {
                        iteration_count++;
                        current = "%s_%s".formatted(String.valueOf(iteration_count), String.valueOf(row.getCell(0)));
                    }
                }

                if (!map.containsKey(current)) {
                    map.put(current, new ArrayList<>());
                }
                List<String> currentList = map.get(current);
                for (Cell cell : row) {
                    if (i != 0) {
                        currentList.add(String.valueOf(cell).replace(" ", ""));
                    }
                    i++;
                }
                prev = current;
            }
            j++;
        }
    }

    public void writeFile(String filepath) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filepath))) {
            String a = null;
            for (List<String> items: map.values()) {
                a = "%s\n".formatted(items.toString()
                                .replace(" ", "")
                                .replace(",", " ")
                                .replace("[", "")
                                .replace("]", ""))
                        .toUpperCase(Locale.ROOT);
                writer.write(a);
            }
        } catch (IOException e) {
            System.out.println("Error writing file:" + e.getMessage());
            e.printStackTrace();
        }
    }




    public static void main(String[] args) throws IOException {
        String filepath = "/home/peeter/IdeaProjects/iti0301-2021/Tests/src/main/resources/tshekid.xlsx";
        String writableFilePath = "/home/peeter/IdeaProjects/iti0301-2021/Tests/src/main/resources/w.txt";
        Loader loader = new Loader(filepath);
        loader.formatFileToHashMap();
        loader.writeFile(writableFilePath);
    }

}
