/**
 * MimeString Class
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
	 * Implements any input-field from a form that can be represented as a string
	 *
	 * @see MimePart
	 * @see MimeFile
	 * @see HTTPForm
	 */
	public class MimeString implements MimePart
	{
		private const crlf= "\r\n";

		// Content parameters
		private var name:String;
		private var contentType:String;
		private var charset:String;
		private var content:String;

		/**
		 * Factory-Method: Creates a new MimeString with the supplied name, content, and optional charset
		 */

		public static function fromString(name:String,content:String,charset:String = null)
		{
			var result:MimeString = new MimeString();

			result.name = name;
			result.setContent(content,charset);

			return result;
		}
		

		/**
		 * Set the content of this field.
		 *
		 * If charset is set, content-type and charset are populated and the content is written with an extra linebreak at the end, as in this example:
		 *	From: Nathaniel Borenstein <nsb@bellcore.com> 
		 *	To:  Ned Freed <ned@innosoft.com> 
		 *	Subject: Sample message 
		 *	MIME-Version: 1.0 
		 *	Content-type: multipart/mixed; boundary="simple boundary" 
		 *	This is the preamble.  It is to be ignored, though it 
		 *	is a handy place for mail composers to include an 
		 *	explanatory note to non-MIME compliant readers. 
		 *	--simple boundary 
		 *
		 *	This is implicitly typed plain ASCII text.
		 *	It does NOT end with a linebreak.
		 *	--simple boundary
		 *	Content-type: text/plain; charset=us-ascii
		 *
		 *	This is explicitly typed plain ASCII text. 
		 *	It DOES end with a linebreak. 
		 *
		 *	--simple boundary-- 
		 *	This is the epilogue.  It is also to be ignored
		 *
		 * @param content The new content of the field
		 * @param charset The optional charset of the string, if none set, uses default us-ascii
		 */
		private function setContent(content:String, charset:String = null)
		{
			if (charset != null)
			{
				this.contentType = "text/plain";
				this.charset = charset;
				//this.content.writeMultiByte(content + crlf,charset);
				this.content = content;
			}

			else
			{
				this.contentType = null;
				this.charset = null;
				//this.content.writeMultiByte(content,"us-ascii");
				this.content = content;
			}
		}


		public function getName():String
		{
			return this.name;
		}

		public function getFilename():String
		{
			return null;
	
		}

		public function getHead():String
		{
			if (this.contentType == null)
			{
				return null;
			}

			else
			{
				return "Content-Type: " + this.contentType + "; charset=" + this.charset;
			}
		}

		public function getBody():ByteArray
		{
			var result:ByteArray = new ByteArray();

			if (this.contentType != null)
			{
				result.writeMultiByte(this.content, this.charset);
			}

			else
			{
				result.writeUTFBytes(this.content + crlf);
			}

			return result;
		}
		
	}
}

