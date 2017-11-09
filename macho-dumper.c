#include <stdio.h>
#include <stdlib.h>
#include <mach-o/loader.h>
#include <mach-o/swap.h>


/** Mach-O Header **/
/**
 * 数据读取方法
 * @param obj_file
 * @param offset
 * @param size
 * @return
 */
void *load_bytes(FILE *obj_file, int offset, int size) {
    void *buffer = calloc(1, size);
    fseek(obj_file, offset, SEEK_SET);
    fread(buffer, size, 1, obj_file);
    return buffer;
}

void dump_segment_commands(FILE *obj_file, int offset, int is_swap, uint32_t ncmds) {
    int actual_offset = offset;
    
    for (int i = 0; i < ncmds; ++ i) {
        load_command *cmd = (load_command *)load_bytes(obj_file, actual_offset, sizeof(load_command));
        
        if (is_swap) {
            swap_load_command(cmd, NX_UnknownByteOrder);
        }
        
        if (cmd -> cmd == LC_SEGMENT_64) {
            segment_command_64 *segment_64 = (segment_command_64 *) load_bytes(obj_file, actual_offset,
                                                                               sizeof(segment_command_64));
            if (is_swap) {
                swap_segment_command_64(segment_64, NX_UnknownByteOrder);
            }
            printf("seg: %s\n", segment_64 -> segname);
            free(segment_64);
        }
        else {
            segment_command *segment = (segment_command *)load_bytes(obj_file, actual_offset, sizeof(segment_command));
            if (is_swap) {
                swap_segment_command(segment, NX_UnknownByteOrder);
            }
            printf("seg: %s\n", segment -> segname);
            free(segment);
        }
        
        actual_offset += cmd -> cmdsize;
        free(cmd);
    }
}

void dump_mach_header(FILE *obj_file, int offset, int is_64, int is_swap) {
    
    uint32_t ncmds;
    int load_commands_offset = offset;
    
    if (is_64) {
        int header_size = sizeof(mach_header_64);
        mach_header_64 *header = (mach_header_64 *)load_bytes(obj_file, offset, header_size);
        if (is_swap) {
            swap_mach_header_64(header, NX_UnknownByteOrder);
        }
        
        ncmds = header -> ncmds;
        load_commands_offset += header_size;
        
        free(header);
        
        dump_segment_commands(obj_file, load_commands_offset, is_swap, ncmds);
    }
    else {
        int header_size = sizeof(mach_header);
        mach_header *header = (mach_header *)load_bytes(obj_file, offset, header_size);
        if (is_swap) {
            swap_mach_header(header, NX_UnknownByteOrder);
        }
        
        ncmds = header -> ncmds;
        load_commands_offset += header_size;
        
        free(header);
    }
    
}

/** Magic Model **/

/**
 * 检测 file 的架构
 * 判断 mach_header 和 mach_header_64
 * @param magic
 * @return
 */
int is_magic_64(uint32_t magic) {
    return magic == MH_MAGIC_64 || magic == MH_CIGAM_64;
}

/**
 * 检测端序
 * 依据字节顺序分类，大端和小端，暂时不考虑例如 DPD-11 为例的混合序
 * @param magic
 * @return
 */
int should_swap_bytes(uint32_t magic) {
    return magic == MH_CIGAM || magic == MH_CIGAM_64;
}

/**
 * 根据读入文件，取出 magic
 * @param obj_file
 * @param offset
 * @return
 */
uint32_t read_magic(FILE *obj_file, int offset) {
    uint32_t magic;
    fseek(obj_file, offset, SEEK_SET);
    fread(&magic, sizeof(uint32_t), 1, obj_file);
    return magic;
}

/** API and function entrance **/

/**
 * dump 调用方法
 * This is the entrance function for all dumper programming
 * @param obj_file
 */
void dump_segments(FILE *obj_file) {
    uint32_t magic = read_magic(obj_file, 0);
    int is_64 = is_magic_64(magic);
    int is_swap = should_swap_bytes(magic);
    
    printf("magic: 0x%X \nis_64: %d \nis_swap: %d \n", magic, is_64, is_swap);
    
    dump_mach_header(obj_file, 0, is_64, is_swap);
}

int main() {
    printf("macho-dumper start work. \n");
    
    const char *filename = "demo";
    
    FILE *obj_file = fopen(filename, "rb");
    
    printf("%p\n", obj_file);
    
    dump_segments(obj_file);
    
    fclose(obj_file);
    
    return 0;
}

