package kha.js.graphics;

class VertexBuffer implements kha.graphics.VertexBuffer {
	private var buffer: Dynamic;
	private var data: Array<Float>;
	
	public function new(vertexCount: Int) {
		buffer = Sys.gl.createBuffer();
		data = new Array<Float>();
		data[vertexCount - 1] = 0;
	}
	
	public function lock(?start: Int, ?count: Int): Array<Float> {
		return data;
	}
	
	public function unlock(): Void {
		Sys.gl.bindBuffer(Sys.gl.ARRAY_BUFFER, Sys.gl.createBuffer());
		Sys.gl.bufferData(Sys.gl.ARRAY_BUFFER, new Float32Array(data), Sys.gl.STATIC_DRAW);
	}
	
	//void vertexAttribPointer(GLuint indx, GLint size, GLenum type, GLboolean normalized, GLsizei stride, GLintptr offset)
	public function set(): Void {
		Sys.gl.bindBuffer(Sys.gl.ARRAY_BUFFER, Sys.gl.createBuffer());
		//var attr = gl.getAttribLocation(prog, attr_name);
		Sys.gl.enableVertexAttribArray(0);
		Sys.gl.vertexAttribPointer(0, data.length, Sys.gl.FLOAT, false, 0, 0);
	}
}