/**
 * MimePart Class
 *
 * (C) David Verhasselt 2007
 * Licensed under the MIT license
 */
package crowdway.http
{
	import flash.utils.ByteArray;

	/**
	 * Interface that defines the message parts a HTTPForm is compiled from.
	 *
	 * @see HTTPForm
	 * @see MimeString
	 * @see MimeFile
	 */
	public interface MimePart
	{
		/**
		 * Get the name of this field
		 *
		 * @return The name of this field, for example "age"
		 */
		function getName():String;

		/**
		 * Get the filename of this field (only for file-types). If there is none or not available, it returns null.
		 *
		 * @return The filename of this file, for example "horse.txt", or null
		 */
		function getFilename():String;

		/**
		 * Get the head-string of this field, or null if not available.
		 *
		 * A head-string starts with "Content-Type: " and includes the content-type, an optional charset-parameter, and an optional boundary.
		 *
		 * @return The head-string, or null if not available. Does not include the final CRLF
		 */
		function getHead():String;

		/**
		 * Get the actual content of this field
		 *
		 * @return The content of this field, not including the final CRLF
		 */
		function getBody():ByteArray;
	}
}
