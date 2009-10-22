/**
 * MimeFile Class
 *
 * (C) David Verhasselt 2007
 * Licensed under the MIT license
 */
package crowdway.http
{
	import crowdway.http.MimePart;

	import flash.utils.ByteArray;
	import flash.events.*;
	import mx.utils.StringUtil;

	import flash.net.*;


	/**
	 * Implements the "file" input-field
	 *
	 * @see MimePart
	 * @see MimeString
	 * @see HTTPForm
	 */
	public class MimeFile implements MimePart
	{
		private static const crlf:String = "\r\n";

		// Content parameters
		private var name:String;
		private var fileName:String;
		private var contentType:String;
		private var charset:String;
		private var content:ByteArray;


		/**
		 * Factory Method: Creates a text/plain MimeFile with the supplied name, filename, content and optional charset. 
		 *
		 * @param name The name of the new MimeFile
		 * @param fileName The filename of the new MimeFile
		 * @param content The content of the new MimeFile
		 * @param charset The optional charset of the content. Defaults to "us-ascii"
		 *
		 * @return A new MimeFile based on the supplied parameters
		 */
		static public function fromText(name:String,fileName:String,content:String,charset:String = "us-ascii"):MimeFile
		{
			var result:MimeFile = new MimeFile();

			result.name = name;
			result.fileName = fileName;
			result.contentType = "text/plain";
			result.content = new ByteArray();
			result.content.writeMultiByte(content,charset);
			result.charset = charset;

			return result;
		}

		/**
		 * Factory Method: Creates a binary MimeFile with the supplied name, filename, content and optional content-type.
		 *
		 * @param name The name of the new MimeFile
		 * @param fileName The filename of the new MimeFile
		 * @param content The content of the new MimeFile
		 * @param contentType The optional content-type of the content. Defaults to "application/octet-stream"
		 *
		 * @return A new MimeFile based on the supplied parameters
		 */
		static public function fromByteArray(name:String,fileName:String,content:ByteArray,contentType:String = "application/octet-stream"):MimeFile
		{
			var result:MimeFile = new MimeFile();
			
			result.name = name;
			result.fileName = fileName;
			result.contentType = contentType;
			result.content = content;

			return result;
		}

		public function getName():String
		{
			return this.name;
		}

		public function getFilename():String
		{
			return this.fileName;
		}	
		
	
		public function getHead():String	
		{
			var head:String = "Content-Type: ";

			head += this.contentType;

			if (this.charset != null)
			{
				head += "; charset=" + this.charset;
			}
		
			return head;
		}
			
				
	
		public function getBody():ByteArray
		{
			this.content.position = 0;
			return this.content;
		}
			
	}
}
