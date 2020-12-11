import com.neonexsoft.common.crypt.seed.SeedCBC;
import com.nns.common.util.WebUtil;
import com.sun.org.apache.xml.internal.security.utils.Base64;

public class Test {
	
	public static String resultStr;
    public static String encryptKey = "1234567890123456";
    public static String charset = "UTF-8";
	
    public static void main(String [] args) throws Exception {
		testEncrypt();
		testDecrypt();
	}
	
    public static void testEncrypt() throws Exception {

        String pwd = "암호입니다.";
        
        SeedCBC seedCBC = new SeedCBC();
        byte[] result = seedCBC.encrypt(encryptKey.getBytes(charset), WebUtil.makeCbcKey(encryptKey.getBytes(charset)), pwd.getBytes(charset), 0, pwd.getBytes(charset).length);
        
        resultStr = Base64.encode(result);
        
        System.out.println(resultStr);
    }
    
    public static void testDecrypt() throws Exception {
        
        byte[] textBytes = Base64.decode(resultStr);
        
        SeedCBC seedCBC = new SeedCBC();
        byte[] result = seedCBC.decrypt(encryptKey.getBytes(charset), WebUtil.makeCbcKey(encryptKey.getBytes(charset)), textBytes, 0, textBytes.length);
        
        System.out.println(new String(result, charset));
    }
}
