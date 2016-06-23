// Cryptography Logics adopted from example by Debadatta Mishra( PIKU )

package hk.edu.cuhk.cse.told;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

public class Footprint {

	private static String algorithm = "DES";
	
	private static String keystring = "H1e1ov4B5ac=";
	
	private static int maxFootprintLength = 100000;
	
	public static String getTimestamp(){
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat format = new SimpleDateFormat("MM-dd HH:mm");
		return format.format(calendar.getTime());
	}
	
	public static String newFootprint(){
		return getEncryptedContents("<newfile> " + getTimestamp(), keystring);
	}
	
	public static String modifiedFootprint(){
		return getEncryptedContents("<modified> " + getTimestamp(), keystring);
	}
	
	public static String updateFootprint(String oldFootprint, String author, int projectSize){
		String content = getDecryptedContents(oldFootprint, keystring);
		if (content == null){
			content = "";
		}
		content += author + " [" + String.valueOf(projectSize) + "] at " + getTimestamp() + "\n";
		
		// Trim the content if it is too large
		if (content.length() > maxFootprintLength){
			content = content.substring(content.length() - maxFootprintLength, -1);
		}
		return getEncryptedContents(content, keystring);
	}

	public static String generateSecretKey() {

		String secretKeyString = null;

		try {
			KeyGenerator keyGen = KeyGenerator.getInstance(algorithm);
			SecretKey secretKey = keyGen.generateKey();
			byte[] secretKeyBytes = secretKey.getEncoded();
			secretKeyString = new sun.misc.BASE64Encoder().encode(secretKeyBytes);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return secretKeyString;
	}

	public static String getDecryptedContents(String contents, String keyString) {
		String decryptedString = null;
		try {
			byte[] contentBytes = new sun.misc.BASE64Decoder().decodeBuffer(contents);
			SecretKey key = getKeyInstance(keyString);
			Cipher ecipher = Cipher.getInstance(algorithm);
			ecipher.init(Cipher.DECRYPT_MODE, key);
			byte[] encryptedBytes = ecipher.doFinal(contentBytes);
			decryptedString = new String(encryptedBytes);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return decryptedString;
	}

	public static String getEncryptedContents(String contents, String keyString) {

		String encryptedString = null;

		try {
			byte[] contentBytes = contents.getBytes();
			SecretKey key = getKeyInstance(keyString);
			Cipher ecipher = Cipher.getInstance(algorithm);
			ecipher.init(Cipher.ENCRYPT_MODE, key);
			byte[] encryptedBytes = ecipher.doFinal(contentBytes);
			encryptedString = new sun.misc.BASE64Encoder()
					.encode(encryptedBytes);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return encryptedString;
	}

	private static SecretKey getKeyInstance(String secretKeyString) {

		SecretKey secretKey = null;
		try {
			byte[] b2 = new sun.misc.BASE64Decoder().decodeBuffer(secretKeyString);
			secretKey = new SecretKeySpec(b2, algorithm);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return secretKey;

	}
}
