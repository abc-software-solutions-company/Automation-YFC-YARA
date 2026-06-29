import fs from "fs";
import path from "path";

export function saveTokenToCSV(token: string, fileName: string) {
    const dataDir = path.resolve(process.cwd(), "data");
    if (!fs.existsSync(dataDir)) {
        fs.mkdirSync(dataDir, { recursive: true });
    }
    const filePath = path.join(dataDir, fileName);
    if (!fs.existsSync(filePath)) {
        fs.writeFileSync(filePath, "token\n");
    }
    fs.appendFileSync(filePath, `${token}\n`);
    console.log(`✅ Token successfully saved to: data/${fileName}`);
}
