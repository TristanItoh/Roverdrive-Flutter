"""
Generates a properly UV-mapped cube as a .glb file.
Each face of the cube gets full 0->1 UV coverage so textures map correctly.

Usage:
    pip3 install pygltflib
    python3 make_cube.py
    
Output: assets/models/cube.glb
"""

import struct
import json
import base64
import os

def make_cube_glb(output_path):
    # 6 faces, each face = 4 vertices (we can't share vertices because UVs differ per face)
    # Each vertex has: position (3 floats) + normal (3 floats) + uv (2 floats)

    # Face definitions: (normal, 4 corner positions, uv coords)
    # Cube goes from -0.5 to 0.5 on each axis (1 unit cube)
    faces = [
        # +Y top
        {
            'normal': (0, 1, 0),
            'positions': [(-0.5, 0.5, 0.5), (0.5, 0.5, 0.5), (0.5, 0.5, -0.5), (-0.5, 0.5, -0.5)],
            'uvs': [(0,1),(1,1),(1,0),(0,0)],
        },
        # -Y bottom
        {
            'normal': (0, -1, 0),
            'positions': [(-0.5,-0.5, 0.5),(0.5,-0.5, 0.5),(0.5,-0.5,-0.5),(-0.5,-0.5,-0.5)],
            'uvs': [(0,0),(1,0),(1,1),(0,1)],
        },
        # +Z front
        {
            'normal': (0, 0, 1),
            'positions': [(-0.5,-0.5, 0.5),(0.5,-0.5, 0.5),(0.5, 0.5, 0.5),(-0.5, 0.5, 0.5)],
            'uvs': [(0,0),(1,0),(1,1),(0,1)],
        },
        # -Z back
        {
            'normal': (0, 0, -1),
            'positions': [(0.5,-0.5,-0.5),(-0.5,-0.5,-0.5),(-0.5, 0.5,-0.5),(0.5, 0.5,-0.5)],
            'uvs': [(0,0),(1,0),(1,1),(0,1)],
        },
        # +X right
        {
            'normal': (1, 0, 0),
            'positions': [(0.5,-0.5, 0.5),(0.5,-0.5,-0.5),(0.5, 0.5,-0.5),(0.5, 0.5, 0.5)],
            'uvs': [(0,0),(1,0),(1,1),(0,1)],
        },
        # -X left
        {
            'normal': (-1, 0, 0),
            'positions': [(-0.5,-0.5,-0.5),(-0.5,-0.5, 0.5),(-0.5, 0.5, 0.5),(-0.5, 0.5,-0.5)],
            'uvs': [(0,0),(1,0),(1,1),(0,1)],
        },
    ]

    positions = []
    normals = []
    uvs = []
    indices = []
    base_index = 0

    for face in faces:
        nx, ny, nz = face['normal']
        for (px, py, pz), (u, v) in zip(face['positions'], face['uvs']):
            positions += [px, py, pz]
            normals += [nx, ny, nz]
            uvs += [u, v]
        # Two triangles per face: 0,1,2 and 0,2,3
        i = base_index
        indices += [i, i+2, i+1, i, i+3, i+2]
        base_index += 4

    # Pack binary data
    pos_data = struct.pack(f'{len(positions)}f', *positions)
    nor_data = struct.pack(f'{len(normals)}f', *normals)
    uv_data  = struct.pack(f'{len(uvs)}f', *uvs)
    idx_data = struct.pack(f'{len(indices)}H', *indices)  # unsigned short

    # Pad to 4-byte alignment
    def pad4(data):
        r = len(data) % 4
        return data + b'\x00' * (4 - r) if r else data

    idx_data = pad4(idx_data)
    pos_data = pad4(pos_data)
    nor_data = pad4(nor_data)
    uv_data  = pad4(uv_data)

    # Build buffer layout
    buf = idx_data + pos_data + nor_data + uv_data

    idx_offset = 0
    idx_len    = len(idx_data)
    pos_offset = idx_len
    pos_len    = len(pos_data)
    nor_offset = pos_offset + pos_len
    nor_len    = len(nor_data)
    uv_offset  = nor_offset + nor_len
    uv_len     = len(uv_data)

    vertex_count = 24  # 6 faces * 4 verts
    index_count  = 36  # 6 faces * 6 indices

    # Min/max for positions (required by glTF spec)
    pos_list = [(positions[i], positions[i+1], positions[i+2]) for i in range(0, len(positions), 3)]
    min_pos = [min(p[j] for p in pos_list) for j in range(3)]
    max_pos = [max(p[j] for p in pos_list) for j in range(3)]

    gltf = {
        "asset": {"version": "2.0", "generator": "make_cube.py"},
        "scene": 0,
        "scenes": [{"nodes": [0]}],
        "nodes": [{"mesh": 0}],
        "meshes": [{
            "primitives": [{
                "attributes": {
                    "POSITION": 1,
                    "NORMAL": 2,
                    "TEXCOORD_0": 3
                },
                "indices": 0,
                "material": 0
            }]
        }],
        "materials": [{
            "name": "CubeMaterial",
            "pbrMetallicRoughness": {
                "baseColorFactor": [1.0, 1.0, 1.0, 1.0],
                "metallicFactor": 0.0,
                "roughnessFactor": 1.0
            },
            "doubleSided": False
        }],
        "accessors": [
            {   # 0: indices
                "bufferView": 0,
                "componentType": 5123,  # UNSIGNED_SHORT
                "count": index_count,
                "type": "SCALAR"
            },
            {   # 1: positions
                "bufferView": 1,
                "componentType": 5126,  # FLOAT
                "count": vertex_count,
                "type": "VEC3",
                "min": min_pos,
                "max": max_pos
            },
            {   # 2: normals
                "bufferView": 2,
                "componentType": 5126,
                "count": vertex_count,
                "type": "VEC3"
            },
            {   # 3: UVs
                "bufferView": 3,
                "componentType": 5126,
                "count": vertex_count,
                "type": "VEC2"
            },
        ],
        "bufferViews": [
            {"buffer": 0, "byteOffset": idx_offset, "byteLength": idx_len},
            {"buffer": 0, "byteOffset": pos_offset, "byteLength": pos_len},
            {"buffer": 0, "byteOffset": nor_offset, "byteLength": nor_len},
            {"buffer": 0, "byteOffset": uv_offset,  "byteLength": uv_len},
        ],
        "buffers": [{"byteLength": len(buf)}]
    }

    # Serialize to GLB
    json_str = json.dumps(gltf, separators=(',', ':')).encode('utf-8')
    # Pad JSON to 4-byte boundary with spaces
    while len(json_str) % 4 != 0:
        json_str += b' '

    JSON_CHUNK_TYPE = 0x4E4F534A  # "JSON"
    BIN_CHUNK_TYPE  = 0x004E4942  # "BIN\0"

    json_chunk = struct.pack('<II', len(json_str), JSON_CHUNK_TYPE) + json_str
    bin_chunk  = struct.pack('<II', len(buf), BIN_CHUNK_TYPE) + buf

    total_length = 12 + len(json_chunk) + len(bin_chunk)
    header = struct.pack('<III', 0x46546C67, 2, total_length)  # magic, version, length

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, 'wb') as f:
        f.write(header + json_chunk + bin_chunk)

    print(f"Written: {output_path}")
    print(f"  {vertex_count} vertices, {index_count} indices, {len(buf)} bytes binary")

if __name__ == '__main__':
    make_cube_glb('assets/models/cube8.glb')