package com.android.email.smime;

import java.io.ByteArrayOutputStream;
import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;

public class LineInputStream
extends FilterInputStream
{

	/*
	 * Line buffer.
	 */
	private ByteArrayOutputStream buf;

	/*
	 * Encoding to use when translating bytes to characters.
	 */
	private String encoding;

	/*
	 * End-of-stream flag.
	 */
	private boolean eof;

	/**
	 * Whether we can use block reads.
	 */
	private final boolean blockReads;

	/**
	 * Constructor using the US-ASCII character encoding.
	 * @param in the underlying input stream
	 */
	public LineInputStream(InputStream in)
	{
		this(in, "US-ASCII");
	}

	/**
	 * Constructor.
	 * @param in the underlying input stream
	 * @param encoding the character encoding to use
	 */
	public LineInputStream(InputStream in, String encoding)
	{
		super(in);
		buf = new ByteArrayOutputStream();
		this.encoding = encoding;
		eof = false;
		blockReads = in.markSupported();
	}

	/**
	 * Read a line of input.
	 */
	public String readLine()
	throws IOException
	{
		if (eof)
		{
			return null;
		}
		do
		{
			if (blockReads)
			{
				// Use mark and reset to read chunks of bytes
				final int MIN_LENGTH = 1024;
				int len, pos;

				len = in.available();
				//len = (len < MIN_LENGTH) ? MIN_LENGTH : len;   
				    // is nothing but len = in.available() this need to be restricted to MIN_LENGTH
				len = (len > MIN_LENGTH) ? MIN_LENGTH : len;       
				byte[] b = new byte[len];
				in.mark(len);
				// Read into buffer b
				len = in.read(b, 0, len);
				// Handle EOF
				if (len == -1)
				{
					eof = true;
					if (buf.size() == 0)
					{
						return null;
					}
					else
					{
						// We don't care about resetting buf
						return buf.toString(encoding);
					}
				}
				// Get index of LF in b
				pos = indexOf(b, len, (byte) 0x0a);
				if (pos != -1)
				{
					// Write pos bytes to buf
					buf.write(b, 0, pos);
					// Reset stream, and read pos + 1 bytes
					in.reset();
					pos += 1;
					while (pos > 0)
					{
						len = in.read(b, 0, pos);
						pos = (len == -1) ? -1 : pos - len;
					}
					// Return line
					String ret = buf.toString(encoding);
					buf.reset();
					return ret;
				}
				else
				{
					// Append everything to buf and fall through to re-read.
					buf.write(b, 0, len);
				}
			}
			else
			{
				// We must use character reads in order not to read too much
				// from the underlying stream.
				int c = in.read();
				switch (c)
				{
				case -1:
					eof = true;
					if (buf.size() == 0)
					{
						return null;
					}
					// Fall through and return contents of buffer.
				case 0x0a:                // LF
					String ret = buf.toString(encoding);
					buf.reset();
					return ret;
				default:
					buf.write(c);
				}
			}
		}
		while (true);
	}

	private int indexOf(byte[] b, int len, byte c)
	{
		for (int pos = 0; pos < len; pos++)
		{
			if (b[pos] == c)
			{
				return pos;
			}
		}
		return -1;
	}

}