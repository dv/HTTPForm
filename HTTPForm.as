/* HTTPForm Class
 *
 * Class HTTPForm fakes a form-submission via POST. Includes support for all INPUT-type arguments.
 *
 * (C) David Verhasselt 2006
 * Licensed under the MIT license
 */

package crowdway.http
{
	import crowdway.http.MimeFile;
	import crowdway.http.MimePart;
	import crowdway.http.MimeString;

	import flash.utils.ByteArray;
	import flash.events.*;
	import mx.utils.StringUtil;

	import flash.net.*;


	/**
	 * Class that implements a method to fake html-form uploads using POST-method. Supports all possible fields and file-uploads.
	 *
	 * @see MimePart
	 * @see MimeFile
	 * @see MimeString
	 */
	public class HTTPForm implements IEventDispatcher
	{
		private const crlf:String = "\r\n";
		private const boundaryLength:Number = 10;

		// Variables for net-connection
		private var request:URLRequest;
		private var loader:URLLoader;

		// Variables for content
		private var autoBoundary:String;
		private var fields:Array;


		/**
		 * Generates a random boundary of "length" characters.
		 *
		 * Boundary can exist out of upper-case and lower-case alphanumericals.
		 *
		 * @param length The length of the boundary to be generated
		 * @return The randomly generated boundary
		 */
		private function generateBoundary(length:Number):String
		{
			var boundary:String = new String();
			var map:Array = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
					 "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
					 "0","1","2","3","4","5","6","7","8","9"];

			for (var i:int = length; i > 0; i--)
			{
				boundary += map[Math.floor(Math.random()*map.length)];
			}

			return boundary;
		}

		/**
		 * Generates the body to be sent to the server
		 *
		 * @param boundary The boundary to be used to split the message-parts
		 * @return All the messages from fields compiled in 1 ByteArray
		 */
		public function getBody(boundary:String = null):ByteArray
		{
			var body:ByteArray = new ByteArray();

			if (!boundary)
			{
				if (!autoBoundary)
				{
					autoBoundary = generateBoundary(boundaryLength);
				}

				boundary = autoBoundary;
			}

			body.writeUTFBytes("--" + boundary + crlf);

			for each (var field:MimePart in this.fields)
			{

				// Add the head of the part
				body.writeUTFBytes("content-disposition: form-data; name=\"" + field.getName() + "\";");
				
				if (field.getFilename() != null)
				{
					body.writeUTFBytes(" filename=\"" + field.getFilename() + "\";");
				}

				body.writeUTFBytes(crlf);

				if (field.getHead() != null)
				{
					body.writeUTFBytes(field.getHead() + crlf);
				}

				body.writeUTFBytes(crlf);

				// Add the body and end of the part
				body.writeBytes(field.getBody());
				body.writeUTFBytes(crlf + "--" + boundary + crlf);
			}
		
			return body;
		}
			
				

		/**
		 * Creates a new HTTPForm object with "url" being the URL of the destination
		 *
		 * @url The url of the destination
		 */
		public function HTTPForm(url:String)
		{
			this.request = new URLRequest(url);
			this.loader = new URLLoader();

			this.fields = new Array();

			// Events
			this.loader.addEventListener(flash.events.Event.COMPLETE, checkComplete);
			this.loader.addEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, function():void { trace("Processer - URLLoader.httpStatus"); });
			this.loader.addEventListener(flash.events.ProgressEvent.PROGRESS, function():void { trace("Processor - URLLoader.progress"); });
			this.loader.addEventListener(flash.events.IOErrorEvent.IO_ERROR, function(event:Event):void { trace("Procesosr - URLLoader.ioError"); trace(event);});
			this.loader.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, function():void { trace("Processor ( URLLoader.securityError"); });
		}

		private function checkComplete(event:Event):void
		{
			trace("Complete");
			var loader2:URLLoader = URLLoader(event.target);
			trace("Length: " + loader2.bytesTotal);
			trace("Data: " + loader2.data);
		}

		/**
		 * Returns the correct contentType to be set, including the boundary.
		 *
		 * @param boundary The boundary to be used. Must be consistent with getBody()
		 */
		public function getContentType(boundary:String = null):String
		{
			if (!boundary)
			{
				if (!autoBoundary)
				{
					autoBoundary = generateBoundary(boundaryLength);
				}

				boundary = autoBoundary;
			}

			return "multipart/form-data; boundary=\"" + boundary + "\"";
		}

		/**
		 * Adds a message-part (an input-field or file) to be sent to the destination to this HTTPForm
		 *
		 * @param field The field to be added
		 */
		public function addField(field:MimePart):void
		{
			this.fields.push(field);
		}

		/**
		 * Compiles all the fields together, and sends this HTTPForm to the destination specified on creation
		 */
		public function send():void
		{
			var boundary:String = generateBoundary(10);

			this.request.method = URLRequestMethod.POST;
			this.request.contentType = getContentType(boundary); 
			this.request.data = getBody(boundary);
			this.loader.load(request);
		}


		// IEventDispatcher Implementation
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			this.loader.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function dispatchEvent(event:Event):Boolean
		{
			return this.loader.dispatchEvent(event);
		}

		public function hasEventListener(type:String):Boolean
		{
			return this.loader.hasEventListener(type);
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			return this.loader.removeEventListener(type, listener, useCapture);
		}

		public function willTrigger(type:String):Boolean
		{
			return this.loader.willTrigger(type);
		}
	}
}
