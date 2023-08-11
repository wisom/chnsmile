package com.icefire.chnsmile.uils;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.telephony.TelephonyManager;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Provides static methods to split, check for substrings, change case and
 * compare strings, along with additional string utility methods.
 */
public class StringUtils {

    /**
     * Returns true if input contains the given pattern, which may contain the
     * wildcard character '*'. TODO: need more formal definition. Examples:
     * <p>
     * <pre>
     *  StringUtils.contains("", "") ==> true
     *  StringUtils.contains("abc", "") ==> true
     *  StringUtils.contains("abc", "b") ==> true
     *  StringUtils.contains("abc", "d") ==> false
     *  StringUtils.contains("abcd", "a*d") ==> true
     *  StringUtils.contains("abcd", "*a**d*") ==> true
     *  StringUtils.contains("abcd", "d*a") ==> false
     * </pre>
     */
    public static final boolean contains(String input, String pattern) {
        return contains(input, pattern, false);
    }

    /**
     * Exactly like contains(input, pattern), but case is ignored if
     * ignoreCase==true.
     */
    public static final boolean contains(String input, String pattern,
                                         boolean ignoreCase) {
        // More efficient algorithms are possible, e.g. a modified version of
        // the
        // Rabin-Karp algorithm, but they are unlikely to be faster with such
        // short strings. Also, some contant time factors could be shaved by
        // combining the second FOR loop below with the subset(..) call, but
        // that
        // just isn't important. The important thing is to avoid needless
        // allocations.

        final int n = pattern.length();
        // Where to resume searching after last wildcard, e.g., just past
        // the last match in input.
        int last = 0;
        // For each token in pattern starting at i...
        for (int i = 0; i < n; ) {
            // 1. Find the smallest j>i s.t. pattern[j] is space, *, or +.
            char c = ' ';
            int j = i;
            for (; j < n; j++) {
                char c2 = pattern.charAt(j);
                if (c2 == ' ' || c2 == '+' || c2 == '*') {
                    c = c2;
                    break;
                }
            }

            // 2. Match pattern[i..j-1] against input[last...].
            int k = subset(pattern, i, j, input, last, ignoreCase);
            if (k < 0)
                return false;

            // 3. Reset the starting search index if got ' ' or '+'.
            // Otherwise increment past the match in input.
            if (c == ' ' || c == '+')
                last = 0;
            else if (c == '*')
                last = k + j - i;
            i = j + 1;
        }
        return true;
    }

    public static boolean containsCharacters(String input, char[] chars) {
        char[] inputChars = input.toCharArray();
        Arrays.sort(inputChars);
        for (int i = 0; i < chars.length; i++) {
            if (Arrays.binarySearch(inputChars, chars[i]) >= 0)
                return true;
        }
        return false;
    }

    /**
     * @requires TODO3: fill this in
     * @effects returns the the smallest i>=bigStart s.t.
     * little[littleStart...littleStop-1] is a prefix of big[i...] or
     * -1 if no such i exists. If ignoreCase==false, case doesn't
     * matter when comparing characters.
     */
    private static final int subset(String little, int littleStart,
                                    int littleStop, String big, int bigStart, boolean ignoreCase) {
        // Equivalent to
        // return big.indexOf(little.substring(littleStart, littleStop),
        // bigStart);
        // but without an allocation.
        // Note special case for ignoreCase below.

        if (ignoreCase) {
            final int n = big.length() - (littleStop - littleStart) + 1;
            outerLoop:
            for (int i = bigStart; i < n; i++) {
                // Check if little[littleStart...littleStop-1] matches with
                // shift i
                final int n2 = littleStop - littleStart;
                for (int j = 0; j < n2; j++) {
                    char c1 = big.charAt(i + j);
                    char c2 = little.charAt(littleStart + j);
                    if (c1 != c2 && c1 != toOtherCase(c2)) // Ignore case. See
                        // below.
                        continue outerLoop;
                }
                return i;
            }
            return -1;
        } else {
            final int n = big.length() - (littleStop - littleStart) + 1;
            outerLoop:
            for (int i = bigStart; i < n; i++) {
                final int n2 = littleStop - littleStart;
                for (int j = 0; j < n2; j++) {
                    char c1 = big.charAt(i + j);
                    char c2 = little.charAt(littleStart + j);
                    if (c1 != c2) // Consider case. See above.
                        continue outerLoop;
                }
                return i;
            }
            return -1;
        }
    }

    /**
     * If c is a lower case ASCII character, returns Character.toUpperCase(c).
     * Else if c is an upper case ASCII character, returns
     * Character.toLowerCase(c), Else returns c. Note that this is <b>not
     * internationalized</b>; but it is fast.
     */
    public static final char toOtherCase(char c) {
        int i = c;
        final int A = 'A'; // 65
        final int Z = 'Z'; // 90
        final int a = 'a'; // 97
        final int z = 'z'; // 122
        final int SHIFT = a - A;

        if (i < A) // non alphabetic
            return c;
        else if (i <= Z) // upper-case
            return (char) (i + SHIFT);
        else if (i < a) // non alphabetic
            return c;
        else if (i <= z) // lower-case
            return (char) (i - SHIFT);
        else
            // non alphabetic
            return c;
    }

    /**
     * Exactly like split(s, Character.toString(delimiter))
     */
    public static String[] split(String s, char delimiter) {
        return split(s, Character.toString(delimiter));
    }

    /**
     * Returns the tokens of s delimited by the given delimiter, without
     * returning the delimiter. Repeated sequences of delimiters are treated as
     * one. Examples:
     * <p>
     * <pre>
     *    split("a//b/ c /","/")=={"a","b"," c "}
     *    split("a b", "/")=={"a b"}.
     *    split("///", "/")=={}.
     * </pre>
     * <p>
     * <b>Note that whitespace is preserved if it is not part of the
     * delimiter.</b> An older version of this trim()'ed each token of
     * whitespace.
     */
    public static String[] split(String s, String delimiters) {
        // Tokenize s based on delimiters, adding to buffer.
        StringTokenizer tokenizer = new StringTokenizer(s, delimiters);
        List<String> tokens = new ArrayList<String>();
        while (tokenizer.hasMoreTokens())
            tokens.add(tokenizer.nextToken());

        return tokens.toArray(new String[0]);
    }

    /**
     * Exactly like splitNoCoalesce(s, Character.toString(delimiter))
     */
    public static String[] splitNoCoalesce(String s, char delimiter) {
        return splitNoCoalesce(s, Character.toString(delimiter));
    }

    /**
     * Similar to split(s, delimiters) except that subsequent delimiters are not
     * coalesced, so the returned array may contain empty strings. If s starts
     * (ends) with a delimiter, the returned array starts (ends) with an empty
     * strings. If s contains N delimiters, N+1 strings are always returned.
     * Examples:
     * <p>
     * <pre>
     *    split("a//b/ c /","/")=={"a","","b"," c ", ""}
     *    split("a b", "/")=={"a b"}.
     *    split("///", "/")=={"","","",""}.
     * </pre>
     *
     * @return an array A s.t. s.equals(A[0]+d0+A[1]+d1+...+A[N]), where for all
     * dI, dI.size()==1 && delimiters.indexOf(dI)>=0; and for all c in
     * A[i], delimiters.indexOf(c)<0
     */
    public static String[] splitNoCoalesce(String s, String delimiters) {
        // Tokenize s based on delimiters, adding to buffer.
        StringTokenizer tokenizer = new StringTokenizer(s, delimiters, true);
        List<String> tokens = new ArrayList<String>();
        // True if last token was a delimiter. Initialized to true to force
        // an empty string if s starts with a delimiter.
        boolean gotDelimiter = true;
        while (tokenizer.hasMoreTokens()) {
            String token = tokenizer.nextToken();
            // Is token a delimiter?
            if (token.length() == 1 && delimiters.indexOf(token) >= 0) {
                // If so, add blank only if last token was a delimiter.
                if (gotDelimiter)
                    tokens.add("");
                gotDelimiter = true;
            } else {
                // If not, add "real" token.
                tokens.add(token);
                gotDelimiter = false;
            }
        }
        // Add trailing empty string UNLESS s is the empty string.
        if (gotDelimiter && !tokens.isEmpty())
            tokens.add("");

        return tokens.toArray(new String[0]);
    }

    /**
     * Returns true iff s starts with prefix, ignoring case.
     *
     * @return true iff s.toUpperCase().startsWith(prefix.toUpperCase())
     */
    public static boolean startsWithIgnoreCase(String s, String prefix) {
        final int pl = prefix.length();
        if (s.length() < pl)
            return false;
        for (int i = 0; i < pl; i++) {
            char sc = s.charAt(i);
            char pc = prefix.charAt(i);
            if (sc != pc) {
                sc = Character.toUpperCase(sc);
                pc = Character.toUpperCase(pc);
                if (sc != pc) {
                    sc = Character.toLowerCase(sc);
                    pc = Character.toLowerCase(pc);
                    if (sc != pc)
                        return false;
                }
            }
        }
        return true;
    }

    public static int getStringLength(String s) {
        return s.length();
    }

    /**
     * Replaces all occurrences of old_str in str with new_str
     *
     * @param str     the String to modify
     * @param old_str the String to be replaced
     * @param new_str the String to replace old_str with
     * @return the modified str.
     */
    public static String replace(String str, String old_str, String new_str) {
        int o = 0;
        StringBuilder buf = new StringBuilder();
        for (int i = str.indexOf(old_str); i > -1; i = str.indexOf(old_str,
                i + 1)) {
            if (i > o) {
                buf.append(str.substring(o, i));
            }
            buf.append(new_str);
            o = i + old_str.length();
        }
        buf.append(str.substring(o, str.length()));
        return buf.toString();
    }

    /**
     * Returns a truncated string, up to the maximum number of characters
     */
    public static String truncate(final String string, final int maxLen) {
        if (string.length() <= maxLen)
            return string;
        else
            return string.substring(0, maxLen);
    }

    /**
     * Helper method to obtain the starting index of a substring within another
     * string, ignoring their case. This method is expensive because it has to
     * set each character of each string to lower case before doing the
     * comparison. Uses the default <code>Locale</code> for case conversion.
     *
     * @param str       the string in which to search for the <tt>substring</tt>
     *                  argument
     * @param substring the substring to search for in <tt>str</tt>
     * @return if the <tt>substring</tt> argument occurs as a substring within
     * <tt>str</tt>, then the index of the first character of the first
     * such substring is returned; if it does not occur as a substring,
     * -1 is returned
     */
    public static int indexOfIgnoreCase(String str, String substring) {
        return indexOfIgnoreCase(str, substring, Locale.getDefault());
    }

    /**
     * Helper method to obtain the starting index of a substring within another
     * string, ignoring their case. This method is expensive because it has to
     * set each character of each string to lower case before doing the
     * comparison.
     *
     * @param str       the string in which to search for the <tt>substring</tt>
     *                  argument
     * @param substring the substring to search for in <tt>str</tt>
     * @param locale    the <code>Locale</code> to use when converting the case of
     *                  <code>str</code> and <code>substring</code>. This is necessary
     *                  because case conversion is <code>Locale</code> specific.
     * @return if the <tt>substring</tt> argument occurs as a substring within
     * <tt>str</tt>, then the index of the first character of the first
     * such substring is returned; if it does not occur as a substring,
     * -1 is returned
     */
    public static int indexOfIgnoreCase(String str, String substring,
                                        Locale locale) {
        // Look for the index after the expensive conversion to lower case.
        return str.toLowerCase(locale).indexOf(substring.toLowerCase(locale));
    }

    /**
     * Utility wrapper for getting a String object out of byte [] using the
     * ascii encoding.
     */
    public static String getASCIIString(byte[] bytes) {
        return getEncodedString(bytes, "ISO-8859-1");
    }

    /**
     * Utility wrapper for getting a String object out of byte [] using the
     * UTF-8 encoding.
     */
    public static String getUTF8String(byte[] bytes) {
        return getEncodedString(bytes, "UTF-8");
    }

    /**
     * @return a string with an encoding we know we support.
     */
    private static String getEncodedString(byte[] bytes, String encoding) {
        try {
            return new String(bytes, encoding);
        } catch (UnsupportedEncodingException impossible) {
            throw new RuntimeException(impossible);
        }
    }

    /**
     * Returns the tokens of array concanated to a delimited by the given
     * delimiter, without Examples:
     * <p>
     * <pre>
     *     explode({ "a", "b" }, " ") == "a b"
     *     explode({ "a", "b" }, "") == "ab"
     * </pre>
     */
    public static String explode(String[] array, String delimeter) {
        StringBuilder sb = new StringBuilder();
        if (array.length > 0) {
            sb.append(array[0]);
            for (int i = 1; i < array.length; i++) {
                sb.append(delimeter);
                sb.append(array[i]);
            }
        }
        return sb.toString();
    }

    /**
     * Returns the tokens of a collection concanated to a delimited by the given
     * delimiter.
     */
    public static String explode(Collection<String> collection, String delimiter) {
        StringBuilder sb = new StringBuilder();
        if (!collection.isEmpty()) {
            Iterator<String> i = collection.iterator();
            sb.append(i.next());
            while (i.hasNext()) {
                sb.append(delimiter);
                sb.append(i.next());
            }
        }
        return sb.toString();
    }

    /**
     * Check if a String is null or empty (the length is null).
     *
     * @param s the string to check
     * @return true if it is null or empty
     */
    public static boolean isNullOrEmpty(String s, boolean trim) {
        return s == null || (trim ? s.trim().length() == 0 : s.length() == 0);
    }

    public static boolean isNullOrEmpty(String s) {
        return isNullOrEmpty(s, false);
    }

    public static String removeDoubleSpaces(String s) {
        return s != null ? s.replaceAll("\\s+", " ") : null;
    }

    public static String buildSet(List<?> list) {
        StringBuilder sb = new StringBuilder("(");
        int i = 0;
        for (Object id : list) {
            sb.append(id);
            if (i++ < (list.size() - 1)) {
                sb.append(",");
            }
        }
        sb.append(")");

        return sb.toString();
    }

    public static String getLocaleString(Map<String, String> strMap) {
        return getLocaleString(strMap, "");
    }

    public static String getLocaleString(Map<String, String> strMap,
                                         String defaultStr) {
        String localeLanguageCode = Locale.getDefault().getLanguage();
        if (StringUtils.isNullOrEmpty(localeLanguageCode, true)) {
            localeLanguageCode = "en";
        }

        String str = strMap.get(localeLanguageCode);
        if (StringUtils.isNullOrEmpty(str, true)) {
            str = defaultStr;
        }

        return str;
    }

    /**
     * Like URLEncoder.encode, except translates spaces into %20 instead of +
     *
     * @param s
     * @return
     */
    public static String encodeUrl(String s) {
        if (s == null) {
            return "";
        }
        try {
            return URLEncoder.encode(s, "UTF-8").replaceAll("\\+", "%20");
        } catch (UnsupportedEncodingException e) {
            return URLEncoder.encode(s).replaceAll("\\+", "%20");
        }
    }

    public static String decodeUrl(String s) {
        if (s == null) {
            return "";
        }
        try {
            return URLDecoder.decode(s, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            return URLDecoder.decode(s);
        }
    }

    public static int dip2px(Context context, float dpValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }

    public static int px2dip(Context context, float pxValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (pxValue / scale + 0.5f);
    }

    // 01234567890 后六位 11为
    public static String truncateString(String str, int index) {
        return str.substring(index);
    }

    public static String encodeKey(Object key) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] md5hash = new byte[32];
            byte[] bytes = key.toString().getBytes("utf-8");
            md.update(bytes, 0, bytes.length);
            md5hash = md.digest();
            return ByteUtils.encodeHex(md5hash);
        } catch (Throwable e) {
            e.printStackTrace();
        }
        return key.toString();
    }

    /**
     * StringUtils.getMD5(f);
     *
     * @param f
     * @return
     */
    public static String getMD5(File f) {
        try {
            MessageDigest m = MessageDigest.getInstance("MD5");

            // We read the file in buffers so we don't
            // eat all the memory in case we have a huge plugin.
            byte[] buf = new byte[65536];
            int num_read;

            InputStream in = new BufferedInputStream(new FileInputStream(f));

            while ((num_read = in.read(buf)) != -1) {
                m.update(buf, 0, num_read);
            }

            in.close();

            String result = new BigInteger(1, m.digest()).toString(16);

            // pad with zeros if until it's 32 chars long.
            if (result.length() < 32) {
                int paddingSize = 32 - result.length();
                for (int i = 0; i < paddingSize; i++) {
                    result = "0" + result;
                }
            }

            return result;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 验证输入的邮箱格式是否符合
     *
     * @param email
     * @return 是否合法
     */
    public static boolean isEmail(String email) {
        String str = "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";
        Pattern p = Pattern.compile(str);
        Matcher m = p.matcher(email);
        return m.matches();
    }

    public static boolean IsValidMobileNo(String phone) {
//		String str = "^[1]([3][0-9]{1}|59|58|88|89|86)[0-9]{8}$";
//		Pattern p = Pattern.compile(str);
//		Matcher m = p.matcher(phone);
        if (phone.length() == 11)
            return true;
        return false;
//		return m.matches();
    }

    public static boolean checkUserName(String userName) {
        String regex = "([a-z]|[A-Z]|[0-9]){2,20}";
//		String regex = "^[a-zA-Z]{2,20}$";
        Pattern p = Pattern.compile(regex);
        Matcher m = p.matcher(userName);
        return m.matches();
    }

    public static String getVersionName(Context context, String packageName)
            throws Exception {
        // 获取packagemanager的实例
        PackageManager packageManager = context.getPackageManager();
        // getPackageName()是你当前类的包名，0代表是获取版本信息
        PackageInfo packInfo = packageManager.getPackageInfo(packageName, 0);
        String version = packInfo.versionName;
        return version;
    }

    public static String getAppVersion(Context context) {
        try {
            // 获取packagemanager的实例
            PackageManager packageManager = context.getPackageManager();
            // getPackageName()是你当前类的包名，0代表是获取版本信息
            PackageInfo packInfo = packageManager.getPackageInfo(context.getPackageName(), 0);
            String version = packInfo.versionName;
            return version;
        } catch (Exception e) {
            return "unknown";
        }
    }

    public static String getSystemRELEASE() {
        return android.os.Build.VERSION.RELEASE;
    }

    public static String getMIME(Context context) {
        TelephonyManager tm = (TelephonyManager) context
                .getSystemService(Context.TELEPHONY_SERVICE);
        return tm.getDeviceId();
    }

    /**
     * 把list转成string 以,分隔
     *
     * @return
     */
    public static String getDeleteImages(List<String> strings) {
        if (strings.size() == 0) {
            return "";
        }
        StringBuilder result = new StringBuilder();
        boolean flag = false;
        for (String s : strings) {
            if (flag) {
                result.append(",");
            } else {
                flag = true;
            }
            result.append(s);
        }
        return result.toString();
    }

}
